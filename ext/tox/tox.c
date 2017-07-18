#include "tox.h"
#include "options.h"
#include "client.h"

#define TOX_IS_COMPATIBLE TOX_VERSION_IS_API_COMPATIBLE
TOX_VERSION_REQUIRE(0, 0, 0);

VALUE cTox;

void Init_tox()
{
  if (!TOX_VERSION_IS_ABI_COMPATIBLE()) {
    rb_raise(rb_eLoadError, "incompatible Tox ABI version");
  }

  cTox = rb_define_class("Tox", rb_cObject);

  cTox_cOptions_INIT();
  cTox_cClient_INIT();
}
