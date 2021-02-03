class AppStoreAppsMessageResponse
  def initialize(response_json_hash)
     @response_json_hash = response_json_hash
  end

  def results
    return @response_json_hash[:results]
  end

  def messages
    messages_hash = @response_json_hash[:messages]
    array = []
    messages_hash.each { |i|
      array.push(MessageResponse.new(i))
    }
    return array
  end

end
