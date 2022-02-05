const defaultTheme = require('tailwindcss/defaultTheme')

let containerScreens = Object.assign({}, defaultTheme.screens)

delete containerScreens['2xl']
delete containerScreens['xl']
delete containerScreens['lg']

module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*'
  ],
  theme: {
    container: {
      screens: containerScreens
    },
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
