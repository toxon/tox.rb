#include "friend.h"
#include "tox.h"

// Instance
VALUE mTox_cFriend;

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cFriend_INIT()
{
  mTox_cFriend = rb_define_class_under(mTox, "Friend", rb_cObject);
}
