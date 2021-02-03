class AppStoreInhouseResponse
  def initialize(response_json_hash)
     @response_json_hash = response_json_hash
  end

  def results
    return AppStoreInhouseResults.new(@response_json_hash[:results])
  end

  def messages
    return @response_json_hash[:messages]
  end

  class AppStoreInhouseResults
    def initialize(json_hash)
      @json_hash = json_hash
    end

    def id
      return @json_hash[:id]
    end

    def name
      return @json_hash[:name]
    end

    def platform_type
      return @json_hash[:platformType]
    end

    def platform_code
      return @json_hash[:platformCode]
    end

    def version
      return @json_hash[:version]
    end

    def alt_version
      return @json_hash[:altVersion]
    end

    def display_version
      return @json_hash[:displayVersion]
    end

    def app_id
      return @json_hash[:appId]
    end

    def provisioning_profile
      return @json_hash[:provisioningProfile]
    end
  end
  
end
