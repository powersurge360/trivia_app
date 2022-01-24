FactoryBot.define do
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
    trait :invalid do
      number_of_questions { 0 }
      difficulty { "difficult" }
      category { 2 }
      game_type { 'jeopardy' }
    end

    trait :valid do
      number_of_questions { 1 }
      category { 9  } # General Knowledge, defined in constants initializer
      game_type { 'boolean' }
    end
  end
end
