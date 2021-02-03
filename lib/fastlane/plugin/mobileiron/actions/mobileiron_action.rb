require "fastlane/action"
require_relative "../helper/appstore_apps_message_response"
require_relative "../helper/labels_summary_response"
require_relative "../helper/message_response"
require_relative "../helper/appstore_apps_labels_response"
require_relative "../helper/appstore_inhause_response"
require_relative "../helper/ping_response"
require_relative "../client/mobileiron_api_client"
require_relative "../helper/mobileiron_helper"

## TODO: should always use a file underneath? I think so.
## How should we document the usage of release notes?
module Fastlane
  module Actions
    class MobileironAction < Action

      SPACE_ID = "1"

      def self.run(params)
        params.values # to validate all inputs before looking for the ipa/apk

        base_url = base_url_from_params(params)
        username = username_from_params(params)
        password = password_from_params(params)
        artifact_path = artifact_path_from_params(params)

        # Check exist Artifact
        unless File.exist?(artifact_path)
          UI.user_error!(artifact_not_found(artifact_path))
        end

        # Check Artifact extname
        unless is_valid_artifact_extname(artifact_path)
          UI.user_error!(artifact_extname_not_valid(artifact_path))
        end

        mobileiron_client = Client::MobileironApiClient.new(base_url, username, password, params[:debug])

        # Check available Mobileiron API
        ping_result = mobileiron_client.ping
        if ping_result.nil?
          UI.user_error!(url_not_available(mobileiron_client.get_api_url))
        end
        UI.message("✅ Successfully connected to #{mobileiron_client.get_api_url}")

        UI.message("Upload binary...")
        upload_result = mobileiron_client.appstore_inhouse(artifact_path)
        if upload_result.nil?
          return
        end
        UI.success("✅ Successfully upload binary #{artifact_path} on Mobileiron.")

        app_id = upload_result.results.id
        UI.message("Id: #{app_id}")
        UI.message("AppId: #{upload_result.results.app_id}")
        UI.message("Name: #{upload_result.results.name}")
        UI.message("DisplayVersion: #{upload_result.results.display_version}")
        UI.message("Version: #{upload_result.results.version}")

        # Apply label(s)
        apply_labels = get_value_from_value_or_file(params[:labels], params[:labels_file])
        apply_labels = string_to_array(apply_labels)
        unless apply_labels.nil?
          all_labels = mobileiron_client.get_labels_summary

          unless all_labels.nil?
            apply_labels.each do |apply_label|
              UI.message("Apply label '#{apply_label.strip}' on Mobileiron...")
              label_info = all_labels.results.find { |item| item.name.strip == apply_label.strip }

              if !label_info.nil?
                apply_label_response = mobileiron_client.appstore_apps_labels(app_id, label_info.id, SPACE_ID)

                apply_label_response_message = apply_label_response.messages.first
                success = apply_label_response_message.is_success
                if success
                  UI.success("✅ Successfully Apply label '#{label_info.id}: #{label_info.name}' on Mobileiron.")
                else
                  UI.message("#{apply_label_response_message.type}: #{apply_label_response_message.localized_message}")
                end
              else
                UI.message("Apply label '#{apply_label}' not found.")
              end
            end

            push_update_result = mobileiron_client.appstore_apps_message(app_id)
            success = push_update_result.messages.first.is_success

            if success
              UI.success("✅ Successfully send message update app on Mobileiron.")
            else
              UI.message("#{push_update_result.type}: #{push_update_result.localized_message}")
            end
          end
        end
        UI.success("🎉 Mobileiron upload finished successfully.")
      end

      def self.description
        "Release your app with Mobileiron"
      end

      def self.authors
        ["Roman Ivannikov: rivannikov"]
      end

      # supports markdown.
      def self.details
        "Release your app with Mobileiron"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :base_url,
                                       env_name: "MOBILEIRON_BASE_URL",
                                       description: "Mobileiron API base URL",
                                       optional: false,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :username,
                                       env_name: "MOBILEIRON_USERNAME",
                                       description: "Mobileiron Username",
                                       optional: false,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :password,
                                       env_name: "MOBILEIRON_PASSWORD",
                                       description: "Mobileiron Password",
                                       optional: false,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :artifact_path,
                                       env_name: "MOBILEIRON_ARTIFACT_PATH",
                                       description: "Absolute path to your app's apk/ipa file",
                                       optional: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("mobileiron: Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :labels,
                                       env_name: "MOBILEIRON_LABELS",
                                       description: "Mobileiron Labels",
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :labels_file,
                                       env_name: "MOBILEIRON_LABELS_FILE",
                                       description: "Mobileiron file with Labels",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("mobileiron: Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :debug,
                                       description: "Print verbose debug output",
                                       optional: true,
                                       default_value: false,
                                       is_string: false)
        ]
      end

      def self.base_url_from_params(params)
        base_url = params[:base_url]

        if base_url.nil?
          UI.crash!(ErrorMessage::MISSING_BASE_URL)
        end
        return base_url
      end

      def self.is_valid_artifact_extname(artifact_path)
        return File.extname(artifact_path) == ".apk" || File.extname(artifact_path) == ".ipa"
      end

      def self.username_from_params(params)
        username = params[:username]

        if username.nil?
          UI.crash!(ErrorMessage::MISSING_CREDENTIALS_USERNAME)
        end
        return username
      end

      def self.password_from_params(params)
        password = params[:password]

        if password.nil?
          UI.crash!(ErrorMessage::MISSING_CREDENTIALS_PASSWORD)
        end
        return password
      end

      def self.artifact_path_from_params(params)
        artifact_path = params[:artifact_path]

        if artifact_path.nil?
          UI.crash!(artifact_not_found(artifact_path))
        end
        return artifact_path
      end

      def self.get_value_from_value_or_file(value, path)
        if (value.nil? || value.empty?) && !path.nil?
          begin
            return File.open(path).read
          rescue Errno::ENOENT
            UI.crash!("#{ErrorMessage::INVALID_PATH}: #{path}")
          end
        end
        value
      end

      # Returns the array representation of a string with comma seperated values.
      #
      # Does not work with strings whose individual values have spaces. EX "Hello World" the space will be removed to "HelloWorld"
      def self.string_to_array(string)
        if string.nil? || string.empty?
          return nil
        end
        string.split(";")
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        [:ios, :android].include?(platform)
        true
      end

      def self.example_code
        [
          <<-CODE
            mobileiron(
              base_url: "https://localhost",
              username: "TestUser",
              password: "password",
              artifact_path: "/Users/test/TestApp-0.1.0.ipa",
              labels: "Test label1; TestLabel2"
            )
          CODE
        ]
      end
    end
  end
end
