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

extern VALUE mTox_cClient_eBadSavedataError;

extern VALUE mTox_cFriend_eNotFoundError;
extern VALUE mTox_cFriend_eNotConnectedError;
extern VALUE mTox_cFriend_cOutMessage;

extern VALUE mTox_mOutMessage_eSendQueueAllocError;
extern VALUE mTox_mOutMessage_eTooLongError;
extern VALUE mTox_mOutMessage_eEmptyError;

// Macros

#define RAISE_ENUM(name)               rb_raise(rb_eNotImpError,    name" has unknown value")
#define RAISE_FUNC_RESULT(name)        rb_raise(mTox_eUnknownError, name"() failed")
#define RAISE_FUNC_ERROR_DEFAULT(name) rb_raise(mTox_eUnknownError, name"() failed")
