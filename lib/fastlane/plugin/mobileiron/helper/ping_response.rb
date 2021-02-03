class PingResponse
  def initialize(response_json_hash)
     @response_json_hash = response_json_hash
  end

  def results
    return PingResults.new(@response_json_hash[:results])
  end

  def messages
    return @response_json_hash[:messages]
  end

  class PingResults
    def initialize(json_hash)
      @json_hash = json_hash
    end

    def api_version
      return @json_hash[:apiVersion]
    end

    def vsp_version
      return @json_hash[:vspVersion]
    end
  end
  
end
