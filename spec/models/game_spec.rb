require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:valid_attributes) do
    {
      number_of_questions: 1,
      category: 9, # General Knowledge, defined in constants initializer
      game_type: 'boolean'
    }
  end

  let(:invalid_attributes) do
    {
      number_of_questions: 0,
      difficulty: "difficult",
      category: 2,
      game_type: 'jeopardy',
    }
  end

  describe 'with valid attributes passed' do
    subject { Game.new(valid_attributes) }

    it 'should save' do
      expect(subject.save).to be true
    end

    it 'should default to pending state' do
      subject.save

      expect(subject.game_lifecycle).to eql('pending')
    end

    it 'should have questions up to 50' do
      valid_attrs = valid_attributes.clone
      valid_attrs[:number_of_questions] = 50

      new_game = Game.new(valid_attrs)
      expect(new_game.save).to be true
    end
  end

  describe 'with invalid attributes passed' do
    subject { Game.new(invalid_attributes) }

    it 'should not save' do
      expect(subject.save).to be false
    end

    it 'should not allow questions above 50' do
      valid_attrs = valid_attributes.clone
      valid_attrs[:number_of_questions] = 51

      new_game = Game.new(valid_attrs)

      expect(new_game.save).to be false
    end

    it 'should have errors for game_type' do
      subject.valid?

      expect(subject.errors).to include(:game_type)
    end

    it 'should have errors for difficulty' do
      subject.valid?

      expect(subject.errors).to include(:difficulty)
    end

    it 'should have errors for number_of_questions' do
      subject.valid?

      expect(subject.errors).to include(:number_of_questions)
    end

    it 'should have errors for category' do
      subject.valid?

      expect(subject.errors).to include(:category)
    end
  end
end
