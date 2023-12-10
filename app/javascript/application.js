// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import {Turbo} from "@hotwired/turbo-rails"

Turbo.StreamActions.redirect = function() {
  Turbo.visit(this.target)
}

Turbo.StreamActions.advanced_redirect = function() {
  let url = this.getAttribute('url')
  Turbo.visit(url)
}