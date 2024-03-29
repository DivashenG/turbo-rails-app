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
* To start server `bin/dev`

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
### Disabling Turbo Drive
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
### Styling Turbo Drive progress bar:
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
---
## Turbo Frames & Turbo Stream Templates
- TLDR: Making all CRUD actions on quotes happen on the index page.
### Turbo Frames
- **Turbo Frames** are independent pieces of a web page that can be appended/prepended/replaced or removed without a complete page refresh (and without writing any JS).
#### Simple turbo frame:
- The below links to
```html
<%# app/views/quotes/index.html.erb %>

<main class="container">
  <%= turbo_frame_tag "first_turbo_frame" do %>
    <div class="header">
      <h1>Quotes</h1>
      <%= link_to "New quote", new_quote_path, class: "btn btn--primary" %>
    </div>
  <% end %>

  <%= render @quotes %>
</main>
```
The new "form" only.
```html
<%# app/views/quotes/new.html.erb %>

<main class="container">
  <%= link_to sanitize("&larr; Back to quotes"), quotes_path %>

  <div class="header">
    <h1>New quote</h1>
  </div>

  <%= turbo_frame_tag "first_turbo_frame" do %>
    <%= render "form", quote: @quote %>
  <% end %>
</main>
```

### Turbo Frames cheat sheet (Rules for Turbo Frames)
- Rule 1: When clicking a link within a Turbo Frame, Turbo expects the same id on the target page. It replaces the Frame's content on the source page with the Frame's content on the target page.
- Rule 2: When clicking a link within a Turbo Frame, if there is no Turbo frame with the same id on the target page, the frame disappears and we are served an error (Response has no matching <turbo-frame id="name_of_the_frame"> element is logged in the dev tool console).
- Rule 3: A link can target another frame other than the one it is directly nested in thanks to the `data-turbo-frame` data attribute.
- NB: Special frame `_top` represents the whole page.

### Editing quotes with Turbo Frames
- Use turbo frames to embed edit page in index by passing `quote` variables from _quote.html.erb to edit.

### Turbo Frames and the dom_id helper
- The `turbo_frame_tag` can be passed a string to be converted to a `dom_id`.
```ruby
# If the quote is persisted and its id is 1:
dom_id(@quote) # => "quote_1"

# If the quote is a new record:
dom_id(Quote.new) # => "new_quote"
```

### Showing and deleting quotes
- Fix show and delete to use `data: { turbo_frame: "_top"}` to fix vanishing pages side effect.

### The Turbo Stream format
- Forms in Rails 7 are now submitted with the TURBO_STREAM format.
- To delete using turbo stream:
```ruby
# app/controllers/quotes_controller.rb

def destroy
  @quote.destroy

  respond_to do |format|
    format.html { redirect_to quotes_path, notice: "Quote was successfully destroyed." }
    format.turbo_stream
  end
end
```

```erbruby
<%# app/views/quotes/destroy.turbo_stream.erb %>

<%= turbo_stream.remove "quote_#{@quote.id}" %>
```
- Turbo Stream can perform the following actions:
```ruby
# Remove a Turbo Frame
turbo_stream.remove

# Insert a Turbo Frame at the beginning/end of a list
turbo_stream.append
turbo_stream.prepend

# Insert a Turbo Frame before/after another Turbo Frame
turbo_stream.before
turbo_stream.after

# Replace or update the content of a Turbo Frame
turbo_stream.update
turbo_stream.replace
```
- The turbo_stream helper expects a partial and locals as arguments to know which HTML it needs to append, prepend, replace from the DOM.
- Turbo Frames + TURBO_STREAM format allows for performing precise operations on pieces of our web pages without having to write a single line of JavaScript, therefore preserving the state of our web pages.

### Creating a new quote with turbo frames