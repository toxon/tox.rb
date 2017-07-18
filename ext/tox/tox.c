#include "tox.h"
#include "options.h"

VALUE cTox;

static VALUE cTox_alloc(VALUE klass);
static void  cTox_free(void *ptr);
static VALUE cTox_initialize(VALUE self, VALUE options);
static VALUE cTox_savedata(VALUE self);
static VALUE cTox_id(VALUE self);

void Init_tox()
{
  cTox = rb_define_class("Tox", rb_cObject);
  rb_define_alloc_func(cTox, cTox_alloc);
  rb_define_method(cTox, "initialize", cTox_initialize, 1);
  rb_define_method(cTox, "savedata",   cTox_savedata,   0);
  rb_define_method(cTox, "id",         cTox_id,         0);

  Init_tox_options();
}

VALUE cTox_alloc(const VALUE klass)
{
  cTox_ *tox;

  tox = ALLOC(cTox_);

  return Data_Wrap_Struct(klass, NULL, cTox_free, tox);
}

void cTox_free(void *const ptr)
{
  free(ptr);
}

VALUE cTox_initialize(const VALUE self, const VALUE options)
{
  cTox_          *tox;
  cTox_cOptions_ *tox_options;

  if (Qfalse == rb_funcall(options, rb_intern("is_a?"), 1, cTox_cOptions)) {
    rb_raise(rb_eTypeError, "expected options to be a Tox::Options");
  }

  Data_Get_Struct(self,    cTox_,          tox);
  Data_Get_Struct(options, cTox_cOptions_, tox_options);

  TOX_ERR_NEW error;

  tox->tox = tox_new(tox_options, &error);

  if (error != TOX_ERR_NEW_OK) {
    rb_raise(rb_eRuntimeError, "tox_new() failed");
  }

  return self;
}

VALUE cTox_savedata(const VALUE self)
{
  cTox_ *tox;

  size_t data_size;
  char *data;

  Data_Get_Struct(self, cTox_, tox);

  data_size = tox_get_savedata_size(tox->tox);
  data = ALLOC_N(char, data_size);

  tox_get_savedata(tox->tox, (uint8_t*)data);

  return rb_str_new(data, data_size);
}

VALUE cTox_id(const VALUE self)
{
  cTox_ *tox;

  Data_Get_Struct(self, cTox_, tox);

  char address[TOX_ADDRESS_SIZE];

  tox_self_get_address(tox->tox, (uint8_t*)address);

  char id[2 * TOX_ADDRESS_SIZE];

  for (unsigned long i = 0; i < TOX_ADDRESS_SIZE; ++i) {
    sprintf(&id[2 * i], "%02X", address[i] & 0xFF);
  }

  return rb_str_new(id, 2 * TOX_ADDRESS_SIZE);
}
