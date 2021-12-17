require 'rails_helper'

RSpec.describe "questions/index", type: :view do
  before(:each) do
    assign(:questions, [
      Question.create!(
        body: "MyText",
        answer_1: "Answer 1",
        answer_2: "Answer 2",
        answer_3: "Answer 3",
        answer_4: "Answer 4",
        correct_answer: 2
      ),
      Question.create!(
        body: "MyText2",
        answer_1: "Answer 1",
        answer_2: "Answer 2",
        answer_3: "Answer 3",
        answer_4: "Answer 4",
        correct_answer: 2
      )
    ])
  end

  it "renders a list of questions" do
    render

    expect(Question.count).to eql(2)

    expect(rendered).to match /MyText/
    expect(rendered).to match /MyText2/
    expect(rendered).to match /Answer 1/
    expect(rendered).to match /Answer 2/
    expect(rendered).to match /Answer 3/
    expect(rendered).to match /Answer 4/
  end
end
