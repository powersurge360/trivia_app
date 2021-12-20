require 'rails_helper'

RSpec.describe External::OpenTdb::TokensEndpoint do
  subject { External::OpenTdbService.new }

    describe '#request' do
      it 'should retrieve a token', :vcr do
        response = subject.tokens.request.data

        expect(response).to_not be_falsy
      end
    end
end
