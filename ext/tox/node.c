#include "tox.h"
#include "node.h"

// Instance
VALUE mTox_cNode;

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cNode_INIT()
{
  // Instance
  mTox_cNode = rb_define_class_under(mTox, "Node", rb_cObject);
}
