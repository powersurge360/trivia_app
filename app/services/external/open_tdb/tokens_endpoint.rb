class External::OpenTdb::TokensEndpoint
  attr_accessor :service

  def initialize(service)
    self.service = service
  end

  def request
    response = self.service.conn.get(
      'api_token.php',
      command: :request
    )

    External::OpenTdb::TokensResponse.new(response)
  end

  # Unimplemented because it seems unlikely we'll run into it. At least
  # difficult to test anyways.
  # def reset(token)
  # end
end
