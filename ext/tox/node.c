#include "tox.h"
#include "node.h"

VALUE mTox_cNode;

void mTox_cNode_INIT()
{
  mTox_cNode = rb_define_class_under(mTox, "Node", rb_cObject);
}
