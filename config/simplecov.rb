# frozen_string_literal: true

require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter,
  ],
)

SimpleCov.start do
  add_filter '/spec/'
end
