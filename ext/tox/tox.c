#include "tox.h"
#include "options.h"
#include "node.h"
#include "client.h"

#define TOX_IS_COMPATIBLE TOX_VERSION_IS_API_COMPATIBLE
TOX_VERSION_REQUIRE(0, 0, 0);

VALUE mTox;

void Init_tox()
{
  if (!TOX_VERSION_IS_ABI_COMPATIBLE()) {
    rb_raise(rb_eLoadError, "incompatible Tox ABI version");
  }

  mTox = rb_define_module("Tox");

  mTox_cOptions_INIT();
  mTox_cNode_INIT();
  mTox_cClient_INIT();
}
