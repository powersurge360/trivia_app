# These are hard coded to avoid having to write a periodic job and having
# to deal with cron jobs. We may one day decide to do that anyways
TRIVIA_CATEGORIES = {
  "Any" => nil,
  "General Knowledge" => 9,
  "Entertainment: Books" => 10,
  "Entertainment: Film" => 11,
  "Entertainment: Music" => 12,
  "Entertainment: Musicals & Theatres" => 13,
  "Entertainment: Television" => 14,
  "Entertainment: Video Games" => 15,
  "Entertainment: Board Games" => 16,
  "Science & Nature" => 17,
  "Science: Computers" => 18,
  "Science: Mathematics" => 19,
  "Mythology" => 20,
  "Sports" => 21,
  "Geography" => 22,
  "History" => 23,
  "Politics" => 24,
  "Art" => 25,
  "Celebrities" => 26,
  "Animals" => 27,
  "Vehicles" => 28,
  "Entertainment: Comics" => 29,
  "Science: Gadgets" => 30,
  "Entertainment: Japanese Anime & Manga" => 31,
  "Entertainment: Cartoon & Animations" => 32
}.freeze

DIFFICULTY_CHOICES = {
  "Any" => "",
  "Easy" => "easy",
  "Medium" => "medium",
  "Hard" => "hard"
}.freeze

GAME_TYPES = {
  "Any" => "",
  "Multiple Choice" => "multiple",
  "True / False" => "boolean"
}.freeze

PLAYER_MODES = {
  "Single Player" => "single",
  "Multiplayer" => "multiplayer"
}.freeze
