class External::OpenTdb::TokensResponse
  attr_accessor :response_code, :data

  def initialize(response)
    self.response_code = response.body['response_code']
    self.data = response.body['token']
  end
end
