class TailwindBuilder < ActionView::Helpers::FormBuilder
  FORM_INPUT_CLASS = "bg-purple-500 rounded-xl text-amber-300 my-2 focus:bg-purple-800 w-full"
  FORM_BUTTON_CLASS = "rounded-xl text-amber-300 mb-2 py-2 font-bold mt-auto lg:hover:bg-purple-500 focus:bg-purple-500 bg-purple-800"

  def number_field(method, options = {})
    super(
      method,
      options.reverse_merge(class: FORM_INPUT_CLASS)
    )
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    super(
      method,
      choices,
      options,
      html_options.reverse_merge(class: FORM_INPUT_CLASS),
      &block
    )
  end

  def submit(value, options = {})
    super(
      value,
      options.reverse_merge(class: FORM_BUTTON_CLASS)
    )
  end
end
