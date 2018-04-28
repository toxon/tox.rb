// Self callbacks

void on_self_connection_status_change(
  Tox *tox,
  TOX_CONNECTION connection_status_data,
  VALUE self
);

// Friend callbacks

void on_friend_request(
  Tox *tox,
  const uint8_t *public_key_data,
  const uint8_t *text_data,
  size_t text_length_data,
  VALUE self
);

void on_friend_message(
  Tox *tox,
  uint32_t friend_number_data,
  TOX_MESSAGE_TYPE type,
  const uint8_t *text_data,
  size_t text_length_data,
  VALUE self
);

void on_friend_name_change(
  Tox *tox,
  uint32_t friend_number_data,
  const uint8_t *name_data,
  size_t name_length_data,
  VALUE self
);

void on_friend_status_message_change(
  Tox *tox,
  uint32_t friend_number_data,
  const uint8_t *status_message_data,
  size_t status_message_length_data,
  VALUE self
);

void on_friend_status_change(
  Tox *tox,
  uint32_t friend_number_data,
  TOX_USER_STATUS status_data,
  VALUE self
);

void on_friend_connection_status_change(
  Tox *tox,
  uint32_t friend_number_data,
  TOX_CONNECTION connection_status_data,
  VALUE self
);

// File callbacks

void on_file_chunk_request(
  Tox *tox,
  uint32_t friend_number_data,
  uint32_t file_number_data,
  uint64_t position_data,
  size_t length_data,
  VALUE self
);

void on_file_recv_request(
  Tox *tox,
  uint32_t friend_number_data,
  uint32_t file_number_data,
  enum TOX_FILE_KIND file_kind_data,
  uint64_t file_size_data,
  const uint8_t *filename_data,
  size_t filename_length_data,
  VALUE self
);

void on_file_recv_chunk(
  Tox *tox,
  uint32_t friend_number_data,
  uint32_t file_number_data,
  uint64_t position_data,
  const uint8_t *ptr_data,
  size_t length_data,
  VALUE self
);

void on_file_recv_control(
  Tox *tox,
  uint32_t friend_number_data,
  uint32_t file_number_data,
  TOX_FILE_CONTROL file_control_data,
  VALUE self
);
