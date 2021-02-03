class LabelsSummaryResponse
  def initialize(response_json_hash)
     @response_json_hash = response_json_hash
  end

  def results
    results_hash = @response_json_hash[:results]
    array = []
    results_hash.each { |i|
      array.push(LabelsSummaryResultsItem.new(i))
    }
    return array
  end

  def messages
    return @response_json_hash[:messages]
  end

  def total_count
    return @response_json_hash[:totalCount]
  end

  def result_count
    return @response_json_hash[:resultCount]
  end

  def has_more?
    return @response_json_hash[:hasMore]
  end

  class LabelsSummaryResultsItem
    def initialize(json_hash)
      @json_hash = json_hash
    end

    def id
      return @json_hash[:id]
    end

    def name
      return @json_hash[:name]
    end

    def description
      return @json_hash[:description]
    end

    def is_static
      return @json_hash[:isStatic]
    end

    def criteria
      return @json_hash[:criteria]
    end

    def device_count
      return @json_hash[:deviceCount]
    end

    def device_space_id
      return @json_hash[:deviceSpaceId]
    end

    def device_space_name
      return @json_hash[:deviceSpaceName]
    end

    def device_space_path
      return @json_hash[:deviceSpacePath]
    end

    def row_type
      return @json_hash[:rowType]
    end

  end

end
