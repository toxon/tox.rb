# frozen_string_literal: true

RSpec::Matchers.define :grep do |pattern|
  description do
    "grep #{pattern.inspect} to be non-empty"
  end

  failure_message do |enumerable|
    "expected #{enumerable.inspect}.grep(#{pattern.inspect}) to be non-empty"
  end

  failure_message_when_negated do |enumerable|
    "expected #{enumerable.inspect}.grep(#{pattern.inspect}) to be empty"
  end

  match do |enumerable|
    !enumerable.grep(pattern).empty?
  end
end
