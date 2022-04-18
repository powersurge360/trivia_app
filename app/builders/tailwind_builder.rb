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

  def toggle(method, label_text, options = {}, checked_value = "1", unchecked_value = "0")
    @template.content_tag :div, class: "relative" do
      (
        label(method, class: "flex grow items-center") do
          check_box(
            method,
            options.reverse_merge(
              class: "sr-only peer"
            ),
            checked_value,
            unchecked_value
          ) +
          @template.content_tag(:div, nil, class: "block bg-gray-600 w-14 h-8 m-0 rounded-full peer-checked:bg-purple-500") +
          @template.content_tag(:div, nil, class: "dot absolute left-1 top-1 bg-white w-6 h-6 rounded-full transition peer-checked:translate-x-full") +
          @template.content_tag(:div, class: "mx-2 inline") do
            label_text
          end
        end
      )
    end
  end

  def submit(value, options = {})
    super(
      value,
      options.reverse_merge(class: FORM_BUTTON_CLASS)
    )
  end
end
