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
      return QuestionsEndpoint.new(conn)
    end

    def tokens
      return TokensEndpoint.new(conn)
    end

    private

    def self.valid_response?(response_code)
      case response_code
      when 1
        raise NoResultsError.new
      when 2
        raise InvalidParameterError.new
      when 3
        raise TokenNotFoundError.new
      when 4
        raise TokenEmptyError.new
      end
    end

    # Endpoints

    class QuestionsEndpoint
      attr_accessor :conn

      def initialize(conn)
        self.conn = conn
      end

      def get(**kwargs)
        response = self.conn.get(
          'api.php',
          kwargs
        )

        OpenTdbService.valid_response?(response.body["response_code"])

        response.body['results']
      end
    end

    class TokensEndpoint
      attr_accessor :conn

      def initialize(conn)
        self.conn = conn
      end

      def request
        response = self.conn.get(
          'api_token.php',
          command: :request
        )

        return response.body['token']
      end

      # Unimplemented because it seems unlikely we'll run into it. At least
      # difficult to test anyways.
      # def reset(token)
      # end
    end

    # Errors

    class NoResultsError < StandardError
      def initialize(msg="No results found")
        super
      end
    end

    class InvalidParameterError < StandardError
      def initialize(msg="Invalid parameter")
        super
      end
    end

    class TokenNotFoundError < StandardError
      def initialize(msg="Session token not found")
        super
      end
    end

    class TokenEmptyError < StandardError
      def initialize(msg="Session token has exhausted all possible questions")
        super
      end
    end
  end
end
