require 'rails_helper'

RSpec.describe External::OpenTdbService do
  subject { External::OpenTdbService.new }

  describe '::QuestionsEndpoint' do
    describe '#get' do
      it 'should retrieve a specified amount of questions', :vcr do
        questions_json = subject.questions.get(amount: 10)

        expect(questions_json.count).to eql(10)
      end

      describe 'has no results' do
        it 'should raise an exception', :vcr do
          expect {
            subject.questions.get(
              amount: 50,
              category: 19, # Math category
              difficulty: :easy,
              type: :boolean, # Boolean to reduce likely options
            )
          }.to raise_error(External::OpenTdbService::NoResultsError)
        end
      end

      describe 'invalid token given' do
        it 'should raise an exception', :vcr do
          expect {
            subject.questions.get(
              amount: 50,
              category: 19, # Math category
              token: 'aslkdajsalkjfkalfjalskdjfaslkaf'
            )
          }.to raise_error(External::OpenTdbService::TokenNotFoundError)
        end
      end

      describe 'token exhausted' do
        it 'should raise an exception', :vcr do
          token = subject.tokens.request

          expect {
            subject.questions.get(
              amount: 50,
              category: 19, # Math category
              difficulty: :easy,
              type: :boolean, # Boolean to reduce likely options
              token: token,
            )
          }.to raise_error(External::OpenTdbService::TokenEmptyError)
        end
      end
    end
  end

  describe '::TokensEndpoint' do
    describe '#request' do
      it 'should retrieve a token', :vcr do
        response = subject.tokens.request

        expect(response).to_not be_falsy
      end
    end
  end
end
