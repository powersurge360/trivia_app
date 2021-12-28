require 'rails_helper'

RSpec.describe RetrieveTriviaQuestionsJob, type: :job do
  let (:game) {
    Game.create
  }

  it 'should use the game\'s configuration to collect the questions', :vcr do
    expect(Question.count).to eql(0)

    RetrieveTriviaQuestionsJob.new(game).perform_now

    expect(Question.count).to eql(10)
  end

  describe 'failure states' do
    xit 'should regenerate tokens when token not found'

    xit 'should regenerate tokens when token exhausted'

    xit 'should log an error when an invalid_parameter is found'

    xit 'should move the game state to error when no results are found'

    xit 'should move the game state to error when an invalid parameter is logged'
  end
end
