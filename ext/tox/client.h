#include <ruby.h>

#include <tox/tox.h>

void cTox_cClient_INIT();

typedef struct cTox_cClient_ {
  Tox *tox;
} cTox_cClient_;

extern VALUE cTox_cClient;
