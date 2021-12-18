# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "alpinejs", to: "https://ga.jspm.io/npm:alpinejs@3.7.0/dist/module.esm.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
