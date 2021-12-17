require 'rails_helper'

RSpec.describe "questions/edit", type: :view do
  before(:each) do
    @question = assign(:question, Question.create!(
      body: "MyText",
      answer_1: "MyString",
      answer_2: "MyString",
      answer_3: "MyString",
      answer_4: "MyString",
      correct_answer: 1
    ))
  end

  it "renders the edit question form" do
    render

    assert_select "form[action=?][method=?]", question_path(@question), "post" do

      assert_select "textarea[name=?]", "question[body]"

      assert_select "input[name=?]", "question[answer_1]"

      assert_select "input[name=?]", "question[answer_2]"

      assert_select "input[name=?]", "question[answer_3]"

      assert_select "input[name=?]", "question[answer_4]"

      assert_select "input[name=?]", "question[correct_answer]"
    end
  end
end
