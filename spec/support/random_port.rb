# frozen_string_literal: true

module Support
  module RandomPort
    def random_port
      rand 1024..65_535
    end
  end
end
