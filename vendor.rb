# frozen_string_literal: true

##
# Vendored dependencies configuration.
#
module Vendor
  PREFIX = File.expand_path('vendor', __dir__).freeze

  BIN_PATH = File.join(PREFIX, 'bin').freeze
  LIB_PATH = File.join(PREFIX, 'lib').freeze
  SRC_PATH = File.join(PREFIX, 'src').freeze

  PKG_CONFIG_PATH = File.join(LIB_PATH, 'pkgconfig').freeze

  REPOS =
    Dir[File.join(SRC_PATH, '*')]
    .map(&File.method(:basename))
    .map(&:freeze)
    .freeze

  def self.prepend_env_path_var(name, value)
    ENV[name] = ENV[name] ? "#{value}:#{ENV[name]}" : value
  end

  prepend_env_path_var 'PATH',            BIN_PATH
  prepend_env_path_var 'LD_LIBRARY_PATH', LIB_PATH
  prepend_env_path_var 'PKG_CONFIG_PATH', PKG_CONFIG_PATH
end
