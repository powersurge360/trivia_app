FactoryBot.define do
  factory :player do
    username { "dark_knight" }

    after(:build) do |p, values|
      p.join_code = values.game.encode_hash_id if values.game
    end

    trait :with_game do
      game { create(:game, :lobby_open, channel: channel) }
    end
  end

  factory :game_question do
  end

  factory :question do
    trait :invalid do
      body { "What time is it?" }
      answer_1 { nil }
      answer_2 { nil }
      correct_answer { nil }
      difficulty { "difficult" }
    end

    trait :valid do
      body { "What is the capital of Kentucky?" }
      answer_1 { "Frankfort" }
      answer_2 { "Louisville" }
      answer_3 { "Lexington" }
      answer_4 { "Bowling Green" }
      correct_answer { "Frankfort" }
      difficulty { "easy" }
    end
  end

  factory :game do
    number_of_questions { 1 }
    category { 9 } # General Knowledge, defined in constants initializer
    game_type { "boolean" }
    channel { SecureRandom.uuid }

    trait :lobby_open do
      game_lifecycle { "lobby_open" }
    end

    trait :invalid do
      number_of_questions { 0 }
      difficulty { "difficult" }
      category { 2 }
      game_type { "jeopardy" }
    end

    trait :valid do
      # To be removed, unnecessary
    end
  end
end
