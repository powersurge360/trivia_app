class External::OpenTdb::QuestionsEndpoint
  attr_accessor :service

  def initialize(service)
    self.service = service
  end

  def get(**kwargs)
    response = self.service.conn.get(
      'api.php',
      kwargs
    )

    External::OpenTdb::QuestionsResponse.new(response)
  end
end
