class MessageResponse
  def initialize(response_json_hash)
    @response_json_hash = response_json_hash
  end

  def type
    return @response_json_hash[:type]
  end

  def message_key
    return @response_json_hash[:messageKey]
  end

  def localized_message
    return @response_json_hash[:localizedMessage]
  end

  def is_success
    return message_key().include? "success"
  end

end
