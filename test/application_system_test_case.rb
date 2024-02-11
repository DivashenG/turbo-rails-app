require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # Change :chrome to :headless_chrome to prevent chrome from opening on tests
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
end
