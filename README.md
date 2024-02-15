# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

---
Ruby on Rails 7 App to play with Hotwire & Turbo

[Hotrails](https://www.hotrails.dev/turbo-rails/turbo-rails-tutorial-introduction)

---
## Rails 7 Notes
* `rails new turbo-rails-app --css=sass --javascript=esbuild --database=postgresql`
* To install dependencies and set up db `bin/setup`
* Run the rails server, and the scripts that precompile the CSS and the JavaScript code with the `bin/dev` command
  * This runs (yarn stuff is defined in `package.json`):
```markdown
# Procfile.dev

web: bin/rails server -p 3000
js: yarn build --watch
css: yarn build:css --watch
```
* Scripts live in /bin folder of the Rails app.
* In Gemfile `gem "simple_form"`
```zsh
bundle install
bin/rails generate simple_form:install
```

---
## Testing
- Generate system tests with: `bin/rails g system_test quotes`
- Run with: `bin/rails test:system`

---
## Working with CSS
Our app/assets/stylesheets/ folder will contain four elements:
- The application.sass.scss manifest file to import all our styles.
- A mixins/ folder where we'll add Sass mixins.
  - Only contains one file `_media.scss` - defining breakpoints of media queries
- A config/ folder where we'll add our variables and global styles.
  - Contains the "look and feel" of the app
- A components/ folder where we'll add our components.
- A layouts/ folder where we'll add our layouts.

---
## Turbo Drive
- First part of turbo installed by default in Rails 7 applications. 
  - `gem "turbo-rails"`
```javascript
// app/javascript/application.js

// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
```
- Turbo Drive speeds up our Ruby on Rails applications by converting all link clicks and form submissions into AJAX requests.
- To disable Turbo Drive on a link or a form, we need to add the `data-turbo="false"` data attribute on it.
```html
<main class="container">
  <div class="header">
    <h1>Quotes</h1>
    <%= link_to "New quote",
                new_quote_path,
                class: "btn btn--primary",
                data: { turbo: false } %>
  </div>

  <%= render @quotes %>
</main>

```
- To disable turbo drive for the whole application:
```javascript
// app/javascript/application.js

import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false
```
- Turbo Drive compares the DOM elements with data-turbo-track="reload" in the <head> of the current HTML page and the <head> of the response. If there are differences, Turbo Drive will reload the whole page.
- Styling Turbo Drive progress bar:
```scss
// app/assets/stylesheets/components/_turbo_progress_bar.scss

.turbo-progress-bar {
  background: linear-gradient(to right, var(--color-primary), var(--color-primary-rotate));
}
```
```scss
// app/assets/stylesheets/application.sass.scss

// All the previous code
@import "components/turbo_progress_bar";
```