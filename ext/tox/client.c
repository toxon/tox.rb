#include "tox.h"
#include "client.h"
#include "options.h"

VALUE mTox_cClient;

static VALUE mTox_cClient_alloc(VALUE klass);
static void  mTox_cClient_free(void *ptr);
static VALUE mTox_cClient_initialize_with(VALUE self, VALUE options);
static VALUE mTox_cClient_savedata(VALUE self);
static VALUE mTox_cClient_id(VALUE self);
static VALUE mTox_cClient_kill(VALUE self);

void mTox_cClient_INIT()
{
  mTox_cClient = rb_define_class_under(mTox, "Client", rb_cObject);
  rb_define_alloc_func(mTox_cClient, mTox_cClient_alloc);
  rb_define_method(mTox_cClient, "initialize_with", mTox_cClient_initialize_with, 1);
  rb_define_method(mTox_cClient, "savedata",        mTox_cClient_savedata,        0);
  rb_define_method(mTox_cClient, "id",              mTox_cClient_id,              0);
  rb_define_method(mTox_cClient, "kill",            mTox_cClient_kill,            0);
}

VALUE mTox_cClient_alloc(const VALUE klass)
{
  mTox_cClient_ *tox;

  tox = ALLOC(mTox_cClient_);

  return Data_Wrap_Struct(klass, NULL, mTox_cClient_free, tox);
}

void mTox_cClient_free(void *const ptr)
{
  free(ptr);
}

VALUE mTox_cClient_initialize_with(const VALUE self, const VALUE options)
{
  mTox_cClient_  *tox;
  mTox_cOptions_ *tox_options;

  if (Qfalse == rb_funcall(options, rb_intern("is_a?"), 1, mTox_cOptions)) {
    rb_raise(rb_eTypeError, "expected options to be a Tox::Options");
  }

  Data_Get_Struct(self,    mTox_cClient_,  tox);
  Data_Get_Struct(options, mTox_cOptions_, tox_options);

  TOX_ERR_NEW error;

  tox->tox = tox_new(tox_options, &error);

  if (error != TOX_ERR_NEW_OK) {
    rb_raise(rb_eRuntimeError, "tox_new() failed");
  }

  return self;
}

VALUE mTox_cClient_savedata(const VALUE self)
{
  mTox_cClient_ *tox;

  size_t data_size;
  char *data;

  Data_Get_Struct(self, mTox_cClient_, tox);

  data_size = tox_get_savedata_size(tox->tox);
  data = ALLOC_N(char, data_size);

  tox_get_savedata(tox->tox, (uint8_t*)data);

  return rb_str_new(data, data_size);
}

VALUE mTox_cClient_id(const VALUE self)
{
  mTox_cClient_ *tox;

  Data_Get_Struct(self, mTox_cClient_, tox);

  char address[TOX_ADDRESS_SIZE];

  tox_self_get_address(tox->tox, (uint8_t*)address);

  char id[2 * TOX_ADDRESS_SIZE];

  for (unsigned long i = 0; i < TOX_ADDRESS_SIZE; ++i) {
    sprintf(&id[2 * i], "%02X", address[i] & 0xFF);
  }

  return rb_str_new(id, 2 * TOX_ADDRESS_SIZE);
}

VALUE mTox_cClient_kill(const VALUE self)
{
  mTox_cClient_ *tox;

  Data_Get_Struct(self, mTox_cClient_, tox);

  tox_kill(tox->tox);

  return self;
}
