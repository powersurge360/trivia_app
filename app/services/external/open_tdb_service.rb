# For documentation on this API, see https://opentdb.com/api_config.php

module External
  class OpenTdbService
    attr_accessor :conn

    def initialize
      self.conn = Faraday.new(url: "https://opentdb.com/") do |f|
        f.response :json
      end
    end

    def questions
      return External::OpenTdb::QuestionsEndpoint.new(self)
    end

    def tokens
      return External::OpenTdb::TokensEndpoint.new(self)
    end
  end
end
