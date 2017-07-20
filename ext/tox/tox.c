#include "tox.h"
#include "options.h"
#include "node.h"
#include "client.h"
#include "friend.h"

#if !(TOX_VERSION_IS_API_COMPATIBLE(0, 1, 9))
  #error "Tox API version is not compatible"
#endif

// Instance
VALUE mTox;

/*************************************************************
 * Initialization
 *************************************************************/

void Init_tox()
{
  if (!TOX_VERSION_IS_ABI_COMPATIBLE()) {
    rb_raise(rb_eLoadError, "incompatible Tox ABI version");
  }

  mTox = rb_define_module("Tox");

  mTox_cOptions_INIT();
  mTox_cNode_INIT();
  mTox_cClient_INIT();
  mTox_cFriend_INIT();
}
