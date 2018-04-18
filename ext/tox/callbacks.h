// Self callbacks

void on_self_connection_status_change(
  Tox *tox,
  TOX_CONNECTION connection_status,
  VALUE self
);

// Friend callbacks

void on_friend_request(
  Tox *tox,
  const uint8_t *public_key,
  const uint8_t *data,
  size_t length,
  VALUE self
);

void on_friend_message(
  Tox *tox,
  uint32_t friend_number,
  TOX_MESSAGE_TYPE type,
  const uint8_t *text,
  size_t length,
  VALUE self
);

void on_friend_name_change(
  Tox *tox,
  uint32_t friend_number,
  const uint8_t *name,
  size_t length,
  VALUE self
);

void on_friend_status_message_change(
  Tox *tox,
  uint32_t friend_number,
  const uint8_t *status_message,
  size_t length,
  VALUE self
);

void on_friend_status_change(
  Tox *tox,
  uint32_t friend_number,
  TOX_USER_STATUS status,
  VALUE self
);

void on_friend_connection_status_change(
  Tox *tox,
  uint32_t friend_number,
  TOX_CONNECTION tox_connection,
  VALUE self
);

// File callbacks

void on_file_chunk_request(
  Tox *tox,
  uint32_t friend_number,
  uint32_t file_number,
  uint64_t position,
  size_t length,
  VALUE self
);

void on_file_recv_request(
  Tox *tox,
  uint32_t friend_number,
  uint32_t file_number,
  enum TOX_FILE_KIND file_kind,
  uint64_t file_size,
  const uint8_t *filename,
  size_t filename_length,
  VALUE self
);

void on_file_recv_chunk(
  Tox *tox,
  uint32_t friend_number,
  uint32_t file_number,
  uint64_t position,
  const uint8_t *data,
  size_t length,
  VALUE self
);

void on_file_recv_control(
  Tox *tox,
  uint32_t friend_number,
  uint32_t file_number,
  TOX_FILE_CONTROL file_control,
  VALUE self
);
