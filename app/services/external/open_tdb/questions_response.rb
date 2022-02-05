class External::OpenTdb::QuestionsResponse
  attr_accessor :response_code, :data, :error

  def initialize(response)
    self.response_code = response.body["response_code"]

    self.data = response.body["results"]
  end

  def successful?
    self.error = case response_code
    when 0
      nil
    when 1
      :no_results
    when 2
      :invalid_parameter
    when 3
      :token_not_found
    when 4
      :token_exhausted
    else
      :unknown
    end

    error.nil?
  end
end
