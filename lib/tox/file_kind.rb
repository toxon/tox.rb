# frozen_string_literal: true

module Tox
  ##
  # Represents the possible kinds of file.
  #
  module FileKind
    # Arbitrary file data. Clients can choose to handle it
    # based on the file name or magic or any other way they choose.
    DATA = :data

    # Avatar.
    AVATAR = :avatar
  end
end
