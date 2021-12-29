class External::OpenTdb::QuestionsResponse
  attr_accessor :response_code, :data, :error

  def initialize(response)
    self.response_code = response.body['response_code']

    self.data = response.body['results']
  end

  def successful?
    case self.response_code
    when 0
      self.error = nil
    when 1
      self.error = :no_results
    when 2
      self.error = :invalid_parameter
    when 3
      self.error = :token_not_found
    when 4
      self.error = :token_exhausted
    else
      self.error = :unknown
    end

    self.error.nil?
  end
end
