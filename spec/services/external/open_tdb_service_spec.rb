require 'rails_helper'

RSpec.describe External::OpenTdbService do
  subject { External::OpenTdbService.new }

  describe '::QuestionsEndpoint' do
    describe '#get' do
      it 'should retrieve a specified amount of questions', :vcr do
        questions_json = subject.questions.get(amount: 10)

        expect(questions_json.successful?).to be true
        expect(questions_json.data.count).to eql(10)
      end

      describe 'has no results' do
        it 'should raise an exception', :vcr do
          response = subject.questions.get(
            amount: 50,
            category: 19, # Math category
            difficulty: :easy,
            type: :boolean, # Boolean to reduce likely options
          )

          expect(response.successful?).to be false
          expect(response.error).to be :no_results
        end
      end

      describe 'invalid token given' do
        it 'should raise have an invalid_token error', :vcr do
          response = subject.questions.get(
            amount: 50,
            category: 19, # Math category
            token: 'aslkdajsalkjfkalfjalskdjfaslkaf'
          )

          expect(response.successful?).to be false
          expect(response.error).to be :token_not_found
        end
      end

      describe 'token exhausted' do
        it 'should raise an exception', :vcr do
          token = subject.tokens.request.data

          response = subject.questions.get(
            amount: 50,
            category: 19, # Math category
            difficulty: :easy,
            type: :boolean, # Boolean to reduce likely options
            token: token,
          )

          expect(response.successful?).to be false
          expect(response.error).to be :token_exhausted
        end
      end
    end
  end

  describe '::TokensEndpoint' do
    describe '#request' do
      it 'should retrieve a token', :vcr do
        response = subject.tokens.request.data

        expect(response).to_not be_falsy
      end
    end
  end
end
