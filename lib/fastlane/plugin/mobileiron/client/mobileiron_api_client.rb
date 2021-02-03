require "faraday"
require "faraday_middleware"

require "uri"
require "net/http"

module Fastlane
  module Client
    class MobileironApiClient

      CONTENT_TYPE = "Content-Type"
      APPLICATION_JSON = "application/json"
      APPLICATION_OCTET_STREAM = "application/octet-stream"

      def initialize(base_url, username, password, debug = true)
        @base_url = base_url
        @username = username
        @password = password
        @debug = debug
      end

      # Ping Mobileiron API
      #
      # Returns the Mobileiron API version, otherwise returns nil.
      def ping
        response = connection.get(get_ping_url)
        if response.success?
          PingResponse.new(response.body)
        end
      end

      # Get App labels on Mobileiron
      #
      # Returns the available Mobileiron App label(s), otherwise returns nil.
      def get_labels_summary
        response = connection.get(get_labels_summary_url) do |request|
          request.params[:adminDeviceSpaceId] = "1"
        end
        if response.success?
          LabelsSummaryResponse.new(response.body)
        end
      end

      # Get App label info on Mobileiron
      #
      # Returns the Mobileiron App label info, otherwise returns nil.
      def get_label_summary(label)
        labels = get_labels_summary
        unless labels.nil?
          labels.results.find { |item| item.name == label }
        end
      end

      # Upload artefact to Mobileiron
      #
      # args
      #   artifact - Absolute path to your app's apk/ipa file
      #
      # Throws a user_error if the binary file does not exist
      # Returns status.
      def appstore_inhouse(artifact)
        payload = { :installer => Faraday::FilePart.new(artifact, APPLICATION_OCTET_STREAM) }
        response = connection.post(get_appstore_inhouse_url) do |request|
          request.params[:adminDeviceSpaceId] = "1"
          request.body = payload
        end

        if response.success?
          AppStoreInhouseResponse.new(response.body)
        end
      end

      # Apply app to app group label on Mobileiron
      #
      # args
      #   app_id - App Id from Mobileiron
      #   label_id - Label Id from Mobileiron
      #   space_id - Space Id from Mobileiron
      #
      # Returns status.
      def appstore_apps_labels(app_id, label_id, space_id)
        response = connection.put(get_appstore_apps_labels_url(app_id, label_id)) do |request|
          request.params[:adminDeviceSpaceId] = space_id
        end

        if response.success?
           AppStoreAppsLabelsResponse.new(response.body)
        end
      end

      # Send message to update App on Mobileiron
      #
      # args
      #   app_id - App Id from Mobileiron
      #
      # Throws a user_error if the binary file does not exist
      def appstore_apps_message(app_id)
        response = connection.post(get_appstore_apps_message_url(app_id)) do |request|
          request.headers[CONTENT_TYPE] = APPLICATION_JSON
          request.params[:adminDeviceSpaceId] = "1"
          request.body = JSON.dump({ installIncluded: true, updateIncluded: true, pushApp: true })
        end

        if response.success?
          AppStoreAppsMessageResponse.new(response.body)
        end
      end

      def get_api_url
        @base_url + API_VERSION
      end

      private

      API_VERSION = "/api/v2"

      def get_ping_url
        API_VERSION + "/ping"
      end

      def get_labels_summary_url
        API_VERSION + "/labels/label_summary"
      end

      def get_appstore_inhouse_url
        API_VERSION + "/appstore/inhouse"
      end

      def get_appstore_apps_labels_url(app_id, label_id)
        API_VERSION + "/appstore/apps/#{app_id}/labels/#{label_id}"
      end

      def get_appstore_apps_message_url(app_id)
        API_VERSION + "/appstore/apps/#{app_id}/message"
      end

      def connection
        @connection ||= Faraday.new(url: @base_url) do |conn|
          conn.basic_auth(@username, @password)
          conn.request(:multipart)
          conn.request :url_encoded
          conn.response(:json, parser_options: { symbolize_names: true })
          conn.response(:raise_error) # raise_error middleware will run before the json middleware
          conn.response(:logger, nil, { headers: false, bodies: { request: false, response: true }, log_level: :debug }) if @debug
          conn.adapter(Faraday.default_adapter)
        end
      end

    end
  end
end
