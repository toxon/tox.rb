#include <ruby.h>

#include <tox/tox.h>
#include <tox/toxav.h>

#include "callbacks.h"
#include "audio_video_callbacks.h"

// C extension initialization

void Init_tox();
void mTox_mVersion_INIT();
void mTox_cOptions_INIT();
void mTox_cClient_INIT();
void mTox_cFriend_INIT();
void mTox_cAudioVideo_INIT();
void mTox_cOutFriendFile_INIT();
void mTox_cInFriendFile_INIT();
void mTox_cFriendCallRequest_INIT();
void mTox_cFriendCall_INIT();
void mTox_cAudioFrame_INIT();

// C data

#define mTox_cOptions_CDATA_PROXY_HOST_BUFFER_SIZE 256

typedef struct {
  struct Tox_Options *tox_options;
  char proxy_host[mTox_cOptions_CDATA_PROXY_HOST_BUFFER_SIZE];
} mTox_cOptions_CDATA;

typedef struct {
  Tox *tox;
} mTox_cClient_CDATA;

typedef struct {
  ToxAV *tox_av;
} mTox_cAudioVideo_CDATA;

typedef struct {
  const uint16_t *pcm;
  size_t sample_count;
  uint8_t channels;
  uint32_t sampling_rate;
} mTox_cAudioFrame_CDATA;

// Instances

extern VALUE mTox;

extern VALUE mTox_eNullError;
extern VALUE mTox_eSendQueueError;
extern VALUE mTox_eUnknownError;

extern VALUE mTox_mVersion;
extern VALUE mTox_mUserStatus;
extern VALUE mTox_mConnectionStatus;
extern VALUE mTox_mProxyType;
extern VALUE mTox_cOptions;
extern VALUE mTox_cClient;
extern VALUE mTox_cNode;
extern VALUE mTox_cFriend;
extern VALUE mTox_cAddress;
extern VALUE mTox_cPublicKey;
extern VALUE mTox_cNospam;
extern VALUE mTox_mOutMessage;
extern VALUE mTox_cOutFriendMessage;
extern VALUE mTox_cAudioVideo;
extern VALUE mTox_mFileKind;
extern VALUE mTox_cOutFriendFile;
extern VALUE mTox_cInFriendFile;
extern VALUE mTox_mFileControl;
extern VALUE mTox_cFriendCallRequest;
extern VALUE mTox_cFriendCall;
extern VALUE mTox_cAudioFrame;

extern VALUE mTox_mUserStatus_NONE;
extern VALUE mTox_mUserStatus_AWAY;
extern VALUE mTox_mUserStatus_BUSY;

extern VALUE mTox_mProxyType_NONE;
extern VALUE mTox_mProxyType_HTTP;
extern VALUE mTox_mProxyType_SOCKS5;

extern VALUE mTox_mConnectionStatus_NONE;
extern VALUE mTox_mConnectionStatus_TCP;
extern VALUE mTox_mConnectionStatus_UDP;

extern VALUE mTox_mFileKind_DATA;
extern VALUE mTox_mFileKind_AVATAR;

extern VALUE mTox_mFileControl_RESUME;
extern VALUE mTox_mFileControl_PAUSE;
extern VALUE mTox_mFileControl_CANCEL;

extern VALUE mTox_cClient_eBadSavedataError;

extern VALUE mTox_cFriend_eNotFoundError;
extern VALUE mTox_cFriend_eNotConnectedError;

extern VALUE mTox_mOutMessage_eTooLongError;
extern VALUE mTox_mOutMessage_eEmptyError;

extern VALUE mTox_cOutFriendFile_eNameTooLongError;
extern VALUE mTox_cOutFriendFile_eTooManyError;

// Inline functions

static inline VALUE           mTox_mUserStatus_FROM_DATA(TOX_USER_STATUS data);
static inline VALUE           mTox_mUserStatus_TRY_DATA(TOX_USER_STATUS data);
static inline TOX_USER_STATUS mTox_mUserStatus_TO_DATA(VALUE value);

static inline VALUE          mTox_mProxyType_FROM_DATA(TOX_PROXY_TYPE data);
static inline VALUE          mTox_mProxyType_TRY_DATA(TOX_PROXY_TYPE data);
static inline TOX_PROXY_TYPE mTox_mProxyType_TO_DATA(VALUE value);

static inline VALUE          mTox_mConnectionStatus_FROM_DATA(TOX_CONNECTION data);
static inline VALUE          mTox_mConnectionStatus_TRY_DATA(TOX_CONNECTION data);
static inline TOX_CONNECTION mTox_mConnectionStatus_TO_DATA(VALUE value);

static inline VALUE              mTox_mFileKind_FROM_DATA(enum TOX_FILE_KIND data);
static inline VALUE              mTox_mFileKind_TRY_DATA(enum TOX_FILE_KIND data);
static inline enum TOX_FILE_KIND mTox_mFileKind_TO_DATA(VALUE value);

static inline VALUE                 mTox_mFileControl_FROM_DATA(enum TOX_FILE_KIND data);
static inline VALUE                 mTox_mFileControl_TRY_DATA(enum TOX_FILE_KIND data);
static inline enum TOX_FILE_CONTROL mTox_mFileControl_TO_DATA(VALUE value);

// Macros

#define CDATA(value, cdata_type, cdata)          \
  cdata_type *(cdata);                           \
  Data_Get_Struct((value), cdata_type, (cdata));

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

VALUE mTox_mConnectionStatus_FROM_DATA(const TOX_CONNECTION data)
{
  const VALUE result = mTox_mConnectionStatus_TRY_DATA(data);

  if (result == Qnil) {
    RAISE_ENUM("TOX_CONNECTION");
  }

  return result;
}

VALUE mTox_mConnectionStatus_TRY_DATA(const TOX_CONNECTION data)
{
  switch (data) {
    case TOX_CONNECTION_NONE:
      return mTox_mConnectionStatus_NONE;
    case TOX_CONNECTION_TCP:
      return mTox_mConnectionStatus_TCP;
    case TOX_CONNECTION_UDP:
      return mTox_mConnectionStatus_UDP;
    default:
      return Qnil;
  }
}

TOX_CONNECTION mTox_mConnectionStatus_TO_DATA(const VALUE value)
{
  if (value == mTox_mConnectionStatus_NONE) {
    return TOX_CONNECTION_NONE;
  }
  else if (value == mTox_mConnectionStatus_TCP) {
    return TOX_CONNECTION_TCP;
  }
  else if (value == mTox_mConnectionStatus_UDP) {
    return TOX_CONNECTION_UDP;
  }
  else {
    RAISE_OPTION("Tox::ConnectionStatus");
  }
}

VALUE mTox_mFileKind_FROM_DATA(const enum TOX_FILE_KIND data)
{
  const VALUE result = mTox_mFileKind_TRY_DATA(data);

  if (result == Qnil) {
    RAISE_ENUM("TOX_FILE_KIND");
  }

  return result;
}

VALUE mTox_mFileKind_TRY_DATA(const enum TOX_FILE_KIND data)
{
  switch (data) {
    case TOX_FILE_KIND_DATA:
      return mTox_mFileKind_DATA;
    case TOX_FILE_KIND_AVATAR:
      return mTox_mFileKind_AVATAR;
    default:
      return Qnil;
  }
}

enum TOX_FILE_KIND mTox_mFileKind_TO_DATA(const VALUE value)
{
  if (value == mTox_mFileKind_DATA) {
    return TOX_FILE_KIND_DATA;
  }
  else if (value == mTox_mFileKind_AVATAR) {
    return TOX_FILE_KIND_AVATAR;
  }
  else {
    RAISE_OPTION("Tox::FileKind");
  }
}

VALUE mTox_mFileControl_FROM_DATA(const enum TOX_FILE_KIND data)
{
  const VALUE result = mTox_mFileControl_TRY_DATA(data);

  if (result == Qnil) {
    RAISE_ENUM("TOX_FILE_CONTROL");
  }

  return result;
}

VALUE mTox_mFileControl_TRY_DATA(const enum TOX_FILE_KIND data)
{
  switch (data) {
    case TOX_FILE_CONTROL_RESUME:
      return mTox_mFileControl_RESUME;
    case TOX_FILE_CONTROL_PAUSE:
      return mTox_mFileControl_PAUSE;
    case TOX_FILE_CONTROL_CANCEL:
      return mTox_mFileControl_CANCEL;
    default:
      return Qnil;
  }
}

enum TOX_FILE_CONTROL mTox_mFileControl_TO_DATA(const VALUE value)
{
  if (value == mTox_mFileControl_RESUME) {
    return TOX_FILE_CONTROL_RESUME;
  }
  else if (value == mTox_mFileControl_PAUSE) {
    return TOX_FILE_CONTROL_PAUSE;
  }
  else if (value == mTox_mFileControl_CANCEL) {
    return TOX_FILE_CONTROL_CANCEL;
  }
  else {
    RAISE_OPTION("Tox::FileControl");
  }
}
