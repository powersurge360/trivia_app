require 'rails_helper'

RSpec.describe "questions/new", type: :view do
  before(:each) do
    assign(:question, Question.new(
      body: "MyText",
      answer_1: "MyString",
      answer_2: "MyString",
      answer_3: "MyString",
      answer_4: "MyString",
      correct_answer: 1
    ))
  end

  it "renders new question form" do
    render

    assert_select "form[action=?][method=?]", questions_path, "post" do

      assert_select "textarea[name=?]", "question[body]"

      assert_select "input[name=?]", "question[answer_1]"

      assert_select "input[name=?]", "question[answer_2]"

      assert_select "input[name=?]", "question[answer_3]"

      assert_select "input[name=?]", "question[answer_4]"

      assert_select "input[name=?]", "question[correct_answer]"
    end
  end
end
