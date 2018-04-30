#include <ruby.h>
#include <opus/opusfile.h>

void Init_opus_file();

struct rb_cOpusFile_CDATA {
  OggOpusFile *ogg_opus_file;
};

static VALUE rb_cOpusFile = 0;

static VALUE rb_cOpusFile_alloc(VALUE klass);
static void  rb_cOpusFile_free(struct rb_cOpusFile_CDATA *opus_file_cdata);

static VALUE rb_cOpusFile_initialize(VALUE opus_file, VALUE filename);
static VALUE rb_cOpusFile_seekable_QUESTION(VALUE opus_file);
static VALUE rb_cOpusFile_link_count(VALUE opus_file);
static VALUE rb_cOpusFile_current_link(VALUE opus_file);
static VALUE rb_cOpusFile_serialno(VALUE opus_file, VALUE link);
static VALUE rb_cOpusFile_channel_count(VALUE opus_file, VALUE link);
static VALUE rb_cOpusFile_raw_total(VALUE opus_file, VALUE link);
static VALUE rb_cOpusFile_pcm_total(VALUE opus_file, VALUE link);
static VALUE rb_cOpusFile_bitrate(VALUE opus_file, VALUE link);
static VALUE rb_cOpusFile_bitrate_instant(VALUE opus_file);
static VALUE rb_cOpusFile_raw_tell(VALUE opus_file);
static VALUE rb_cOpusFile_pcm_tell(VALUE opus_file);
static VALUE rb_cOpusFile_vendor(VALUE opus_file, VALUE link);
static VALUE rb_cOpusFile_read(VALUE opus_file, VALUE length);

void Init_opus_file()
{
  rb_cOpusFile = rb_define_class("OpusFile", rb_cObject);

  rb_define_alloc_func(rb_cOpusFile, rb_cOpusFile_alloc);

  rb_define_method(rb_cOpusFile, "initialize",   rb_cOpusFile_initialize,   1);
  rb_define_method(rb_cOpusFile, "seekable?",
                   rb_cOpusFile_seekable_QUESTION, 0);
  rb_define_method(rb_cOpusFile, "link_count",   rb_cOpusFile_link_count,   0);
  rb_define_method(rb_cOpusFile, "current_link", rb_cOpusFile_current_link, 0);
  rb_define_method(rb_cOpusFile, "serialno",     rb_cOpusFile_serialno,     1);
  rb_define_method(rb_cOpusFile, "channel_count",
                   rb_cOpusFile_channel_count, 1);
  rb_define_method(rb_cOpusFile, "raw_total",    rb_cOpusFile_raw_total,    1);
  rb_define_method(rb_cOpusFile, "pcm_total",    rb_cOpusFile_pcm_total,    1);
  rb_define_method(rb_cOpusFile, "bitrate",      rb_cOpusFile_bitrate,      1);
  rb_define_method(rb_cOpusFile, "bitrate_instant",
                   rb_cOpusFile_bitrate_instant, 0);
  rb_define_method(rb_cOpusFile, "raw_tell",     rb_cOpusFile_raw_tell,     0);
  rb_define_method(rb_cOpusFile, "pcm_tell",     rb_cOpusFile_pcm_tell,     0);
  rb_define_method(rb_cOpusFile, "vendor",       rb_cOpusFile_vendor,       1);
  rb_define_method(rb_cOpusFile, "read",         rb_cOpusFile_read,         1);
}

VALUE rb_cOpusFile_alloc(const VALUE klass)
{
  struct rb_cOpusFile_CDATA *const opus_file_cdata =
    ALLOC(struct rb_cOpusFile_CDATA);

  opus_file_cdata->ogg_opus_file = NULL;

  return Data_Wrap_Struct(klass, NULL, rb_cOpusFile_free, opus_file_cdata);
}

void rb_cOpusFile_free(struct rb_cOpusFile_CDATA *const opus_file_cdata)
{
  if (opus_file_cdata->ogg_opus_file) {
    op_free(opus_file_cdata->ogg_opus_file);
  }

  free(opus_file_cdata);
}

VALUE rb_cOpusFile_initialize(const VALUE opus_file, /* const */ VALUE filename)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  const char *filename_data = StringValueCStr(filename);

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  if (opus_file_cdata->ogg_opus_file) {
    rb_raise(rb_eRuntimeError, "already initialized");
  }

  opus_file_cdata->ogg_opus_file = op_open_file(filename_data, NULL);

  if (!opus_file_cdata->ogg_opus_file) {
    rb_raise(rb_eRuntimeError, "can not open file \"%s\"", filename_data);
  }

  return opus_file;
}

VALUE rb_cOpusFile_seekable_QUESTION(const VALUE opus_file)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  if (op_seekable(opus_file_cdata->ogg_opus_file)) {
    return Qtrue;
  }
  else {
    return Qfalse;
  }
}

VALUE rb_cOpusFile_link_count(const VALUE opus_file)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  return INT2NUM(op_link_count(opus_file_cdata->ogg_opus_file));
}

VALUE rb_cOpusFile_current_link(const VALUE opus_file)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  return INT2NUM(op_current_link(opus_file_cdata->ogg_opus_file));
}

VALUE rb_cOpusFile_serialno(const VALUE opus_file, const VALUE link)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  return ULONG2NUM(op_serialno(opus_file_cdata->ogg_opus_file, NUM2INT(link)));
}

VALUE rb_cOpusFile_channel_count(const VALUE opus_file, const VALUE link)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  return INT2NUM(op_channel_count(opus_file_cdata->ogg_opus_file, NUM2INT(link)));
}

VALUE rb_cOpusFile_raw_total(const VALUE opus_file, const VALUE link)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  return LL2NUM(op_raw_total(opus_file_cdata->ogg_opus_file, NUM2INT(link)));
}

VALUE rb_cOpusFile_pcm_total(const VALUE opus_file, const VALUE link)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  return LL2NUM(op_pcm_total(opus_file_cdata->ogg_opus_file, NUM2INT(link)));
}

VALUE rb_cOpusFile_bitrate(const VALUE opus_file, const VALUE link)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  return LONG2NUM(op_bitrate(opus_file_cdata->ogg_opus_file, NUM2INT(link)));
}

VALUE rb_cOpusFile_bitrate_instant(const VALUE opus_file)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  return LONG2NUM(op_bitrate_instant(opus_file_cdata->ogg_opus_file));
}

VALUE rb_cOpusFile_raw_tell(const VALUE opus_file)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  return LL2NUM(op_raw_tell(opus_file_cdata->ogg_opus_file));
}

VALUE rb_cOpusFile_pcm_tell(const VALUE opus_file)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  return LL2NUM(op_pcm_tell(opus_file_cdata->ogg_opus_file));
}

VALUE rb_cOpusFile_vendor(const VALUE opus_file, const VALUE link)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  const OpusTags *const opus_tags_data =
    op_tags(opus_file_cdata->ogg_opus_file, NUM2INT(link));

  if (!opus_tags_data) {
    return Qnil;
  }

  return rb_str_new_cstr(opus_tags_data->vendor);
}

VALUE rb_cOpusFile_read(const VALUE opus_file, const VALUE length)
{
  struct rb_cOpusFile_CDATA *opus_file_cdata = NULL;

  Data_Get_Struct(opus_file, struct rb_cOpusFile_CDATA, opus_file_cdata);

  const int length_data = NUM2INT(length);

  if (length_data < 0) {
    rb_raise(rb_eArgError, "negative length requested");
  }

  opus_int16 buffer_data[length_data];

  const int result_data = op_read(
    opus_file_cdata->ogg_opus_file,
    buffer_data,
    length_data,
    NULL
  );

  if (result_data < 0) {
    rb_raise(rb_eRuntimeError, "can not read");
  }

  const int channel_count_data =
    op_channel_count(opus_file_cdata->ogg_opus_file, -1);

  return rb_str_new(
    (char*)buffer_data,
    sizeof(opus_int16[result_data * channel_count_data])
  );
}
