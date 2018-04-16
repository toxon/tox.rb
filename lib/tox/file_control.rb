# frozen_string_literal: true

module Tox
  ##
  # Represents file control commands.
  #
  module FileControl
    # Sent by the receiving side to accept a file send request. Also sent
    # after a TOX_FILE_CONTROL_PAUSE command to continue sending or receiving.
    RESUME = :resume

    # Sent by clients to pause the file transfer. The initial state of a file
    # transfer is always paused on the receiving side and running on the sending
    # side. If both the sending and receiving side pause the transfer, then both
    # need to send TOX_FILE_CONTROL_RESUME for the transfer to resume.
    PAUSE = :pause

    # Sent by the receiving side to reject a file send request before any other
    # commands are sent. Also sent by either side to terminate a file transfer.
    CANCEL = :cancel
  end
end
