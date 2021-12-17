require 'rails_helper'

RSpec.describe "questions/show", type: :view do
  before(:each) do
    @question = assign(:question, Question.create!(
      body: "MyText",
      answer_1: "Answer 1",
      answer_2: "Answer 2",
      answer_3: "Answer 3",
      answer_4: "Answer 4",
      correct_answer: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Answer 1/)
    expect(rendered).to match(/Answer 2/)
    expect(rendered).to match(/Answer 3/)
    expect(rendered).to match(/Answer 4/)
    expect(rendered).to match(/2/)
  end
end
