module ThemeHelper
  def tw_button_to(name = nil, options = nil, html_options = nil, &block)
    button_to(
      name,
      options,
      html_options.reverse_merge(
        class: "font-bold text-amber-300 rounded-xl mb-2 py-2 bg-purple-800 lg:hover:bg-purple-500 focus:bg-purple-500"
      ),
      &block
    )
  end

  def tw_link_button_to(name = nil, options = nil, html_options = nil, &block)
    link_to(
      name,
      options,
      html_options.reverse_merge(
        class: "font-bold text-amber-300 rounded-xl mb-2 py-2 bg-purple-800 lg:hover:bg-purple-500 focus:bg-purple-500"
      ),
      &block
    )
  end
end
