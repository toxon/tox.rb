#include <ruby.h>

#include <tox/tox.h>

void mTox_cClient_INIT();

typedef struct mTox_cClient_ {
  Tox *tox;
} mTox_cClient_;

extern VALUE mTox_cClient;
