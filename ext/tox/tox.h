#include <ruby.h>

#include <tox/tox.h>

// C extension initialization

void Init_tox();
void mTox_mVersion_INIT();
void mTox_cOptions_INIT();
void mTox_cClient_INIT();
void mTox_cFriend_INIT();

// C data

typedef struct Tox_Options mTox_cOptions_CDATA;

typedef struct {
  Tox *tox;
} mTox_cClient_CDATA;

// Instances

extern VALUE mTox;

extern VALUE mTox_eNullError;
extern VALUE mTox_eUnknownError;

extern VALUE mTox_mVersion;
extern VALUE mTox_mUserStatus;
extern VALUE mTox_mProxyType;
extern VALUE mTox_cOptions;
extern VALUE mTox_cClient;
extern VALUE mTox_cNode;
extern VALUE mTox_cFriend;
extern VALUE mTox_cAddress;
extern VALUE mTox_cPublicKey;
extern VALUE mTox_cNospam;
extern VALUE mTox_mOutMessage;

extern VALUE mTox_mUserStatus_NONE;
extern VALUE mTox_mUserStatus_AWAY;
extern VALUE mTox_mUserStatus_BUSY;

extern VALUE mTox_mProxyType_NONE;
extern VALUE mTox_mProxyType_HTTP;
extern VALUE mTox_mProxyType_SOCKS5;

extern VALUE mTox_cClient_eBadSavedataError;

extern VALUE mTox_cFriend_eNotFoundError;
extern VALUE mTox_cFriend_eNotConnectedError;
extern VALUE mTox_cFriend_cOutMessage;

extern VALUE mTox_mOutMessage_eSendQueueAllocError;
extern VALUE mTox_mOutMessage_eTooLongError;
extern VALUE mTox_mOutMessage_eEmptyError;

// Inline functions

static inline VALUE           mTox_mUserStatus_FROM_DATA(TOX_USER_STATUS data);
static inline VALUE           mTox_mUserStatus_TRY_DATA(TOX_USER_STATUS data);
static inline TOX_USER_STATUS mTox_mUserStatus_TO_DATA(VALUE value);

static inline VALUE          mTox_mProxyType_FROM_DATA(TOX_PROXY_TYPE data);
static inline VALUE          mTox_mProxyType_TRY_DATA(TOX_PROXY_TYPE data);
static inline TOX_PROXY_TYPE mTox_mProxyType_TO_DATA(VALUE value);

// Macros

#define RAISE_TYPECHECK(method_name, arg_name, expected_type) \
  rb_raise(                                                   \
    rb_eTypeError,                                            \
    "Expected method "method_name                             \
      " argument \""arg_name                                  \
      "\" to be a "expected_type                              \
  )

#define RAISE_ENUM(enum_name)      \
  rb_raise(                        \
    rb_eNotImpError,               \
    enum_name" has unknown value"  \
  )

#define RAISE_OPTION(enum_module)    \
  rb_raise(                          \
    rb_eArgError,                    \
    "Invalid value from "enum_module \
  )

#define RAISE_FUNC_RESULT(func_name) \
  rb_raise(                          \
    mTox_eUnknownError,              \
    func_name"() failed"             \
  )

#define RAISE_FUNC_ERROR_DEFAULT(func_name) \
  rb_raise(                                 \
    mTox_eUnknownError,                     \
    func_name"() failed"                    \
  )

#define RAISE_FUNC_ERROR(func_name, exception_class, error) \
  rb_raise(                                                 \
    exception_class,                                        \
    func_name"() failed with "error                         \
  )

// Inline function implementations

VALUE mTox_mUserStatus_FROM_DATA(const TOX_USER_STATUS data)
{
  const VALUE result = mTox_mUserStatus_TRY_DATA(data);

  if (result == Qnil) {
    RAISE_ENUM("TOX_USER_STATUS");
  }

  return result;
}

VALUE mTox_mUserStatus_TRY_DATA(const TOX_USER_STATUS data)
{
  switch (data) {
    case TOX_USER_STATUS_NONE:
      return mTox_mUserStatus_NONE;
    case TOX_USER_STATUS_AWAY:
      return mTox_mUserStatus_AWAY;
    case TOX_USER_STATUS_BUSY:
      return mTox_mUserStatus_BUSY;
    default:
      return Qnil;
  }
}

TOX_USER_STATUS mTox_mUserStatus_TO_DATA(const VALUE value)
{
  if (rb_funcall(mTox_mUserStatus_NONE, rb_intern("=="), 1, value)) {
    return TOX_USER_STATUS_NONE;
  }
  else if (rb_funcall(mTox_mUserStatus_AWAY, rb_intern("=="), 1, value)) {
    return TOX_USER_STATUS_AWAY;
  }
  else if (rb_funcall(mTox_mUserStatus_BUSY, rb_intern("=="), 1, value)) {
    return TOX_USER_STATUS_BUSY;
  }
  else {
    RAISE_OPTION("Tox::UserStatus");
  }
}

VALUE mTox_mProxyType_FROM_DATA(const TOX_PROXY_TYPE data)
{
  const VALUE result = mTox_mProxyType_TRY_DATA(data);

  if (result == Qnil) {
    RAISE_ENUM("TOX_PROXY_TYPE");
  }

  return result;
}

VALUE mTox_mProxyType_TRY_DATA(const TOX_PROXY_TYPE data)
{
  switch (data) {
    case TOX_PROXY_TYPE_NONE:
      return mTox_mProxyType_NONE;
    case TOX_PROXY_TYPE_HTTP:
      return mTox_mProxyType_HTTP;
    case TOX_PROXY_TYPE_SOCKS5:
      return mTox_mProxyType_SOCKS5;
    default:
      return Qnil;
  }
}

TOX_PROXY_TYPE mTox_mProxyType_TO_DATA(const VALUE value)
{
  if (value == mTox_mProxyType_NONE) {
    return TOX_PROXY_TYPE_NONE;
  }
  else if (value == mTox_mProxyType_HTTP) {
    return TOX_PROXY_TYPE_HTTP;
  }
  else if (value == mTox_mProxyType_SOCKS5) {
    return TOX_PROXY_TYPE_SOCKS5;
  }
  else {
    RAISE_OPTION("Tox::ProxyType");
  }
}
