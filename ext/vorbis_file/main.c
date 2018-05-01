#include <ruby.h>
#include <stdbool.h>
#include <vorbis/vorbisfile.h>

void Init_vorbis_file();

struct rb_cVorbisFile_CDATA {
  bool opened;
  OggVorbis_File ogg_vorbis_file;
};

static VALUE rb_cVorbisFile = 0;

static VALUE rb_cVorbisFile_alloc(VALUE klass);
static void  rb_cVorbisFile_free(struct rb_cVorbisFile_CDATA *vorbis_file_cdata);

static VALUE rb_cVorbisFile_initialize(VALUE vorbis_file, VALUE filename);

static VALUE rb_cVorbisFile_vendor(VALUE vorbis_file, VALUE link);

void Init_vorbis_file()
{
  rb_cVorbisFile = rb_define_class("VorbisFile", rb_cObject);

  rb_define_alloc_func(rb_cVorbisFile, rb_cVorbisFile_alloc);

  rb_define_method(rb_cVorbisFile, "initialize", rb_cVorbisFile_initialize, 1);

  rb_define_method(rb_cVorbisFile, "vendor", rb_cVorbisFile_vendor, 1);
}

VALUE rb_cVorbisFile_alloc(const VALUE klass)
{
  struct rb_cVorbisFile_CDATA *const vorbis_file_cdata =
    ALLOC(struct rb_cVorbisFile_CDATA);

  vorbis_file_cdata->opened = false;

  return Data_Wrap_Struct(klass, NULL, rb_cVorbisFile_free, vorbis_file_cdata);
}

void rb_cVorbisFile_free(struct rb_cVorbisFile_CDATA *const vorbis_file_cdata)
{
  if (vorbis_file_cdata->opened) {
    ov_clear(&vorbis_file_cdata->ogg_vorbis_file);
  }

  free(vorbis_file_cdata);
}

VALUE rb_cVorbisFile_initialize(
  const VALUE vorbis_file,
  /* const */ VALUE filename
)
{
  struct rb_cVorbisFile_CDATA *vorbis_file_cdata = NULL;

  const char *filename_data = StringValueCStr(filename);

  Data_Get_Struct(vorbis_file, struct rb_cVorbisFile_CDATA, vorbis_file_cdata);

  if (vorbis_file_cdata->opened) {
    rb_raise(rb_eRuntimeError, "already initialized");
  }

  if (ov_fopen(filename_data, &vorbis_file_cdata->ogg_vorbis_file)) {
    rb_raise(rb_eRuntimeError, "can not open file \"%s\"", filename_data);
  }

  vorbis_file_cdata->opened = true;

  return vorbis_file;
}

VALUE rb_cVorbisFile_vendor(const VALUE vorbis_file, const VALUE link)
{
  struct rb_cVorbisFile_CDATA *vorbis_file_cdata = NULL;

  Data_Get_Struct(vorbis_file, struct rb_cVorbisFile_CDATA, vorbis_file_cdata);

  const struct vorbis_comment *const vorbis_comment_data =
    ov_comment(&vorbis_file_cdata->ogg_vorbis_file, NUM2INT(link));

  if (!vorbis_comment_data) {
    return Qnil;
  }

  return rb_str_new_cstr(vorbis_comment_data->vendor);
}
