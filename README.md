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
## Log
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