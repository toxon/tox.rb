#include <ruby.h>

#include <tox/tox.h>

void Init_tox();

typedef struct cTox_ {
  Tox *tox;
} cTox_;

extern VALUE cTox;
