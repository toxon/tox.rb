#include <ruby.h>

#include <tox/tox.h>

void mTox_cClient_INIT();

extern VALUE mTox_cClient;

typedef struct {
  Tox *tox;
} mTox_cClient_DATA;
