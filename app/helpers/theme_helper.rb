module ThemeHelper
  # Form inputs

  def form_input_class
    "bg-purple-500 rounded-xl text-amber-300 my-2 focus:bg-purple-800 w-full"
  end

  def submit_button_class
    "rounded-xl text-amber-300 mb-2 py-2 font-bold mt-auto lg:hover:bg-purple-500 focus:bg-purple-500 bg-purple-800"
  end

  def button_class
    "font-bold text-amber-300 rounded-xl mb-2 py-2 bg-purple-800 lg:hover:bg-purple-500 focus:bg-purple-500"
  end
end
