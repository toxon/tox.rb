#include "gsttoxaudiosink.h"

GST_DEBUG_CATEGORY_STATIC(gst_tox_audio_sink_debug);
#define GST_CAT_DEFAULT gst_tox_audio_sink_debug

#define gst_tox_audio_sink_parent_class parent_class
G_DEFINE_TYPE(GstToxAudioSink, gst_tox_audio_sink, GST_TYPE_AUDIO_SINK);

/******************************************************************************
 * Types and constants
 ******************************************************************************/

enum {
  PROP_0,
  PROP_TOX_AV,
  PROP_FRIEND_NUMBER
};

/******************************************************************************
 * Function declarations
 ******************************************************************************/

static void gst_tox_audio_sink_class_init(GstToxAudioSinkClass *klass);

static void gst_tox_audio_sink_init(GstToxAudioSink *self);

static void gst_tox_audio_sink_finalize(GObject *object);

static void gst_tox_audio_sink_get_property(
  GObject *object,
  guint prop_id,
  GValue *value,
  GParamSpec *pspec
);

static void gst_tox_audio_sink_set_property(
  GObject *object,
  guint prop_id,
  const GValue *value,
  GParamSpec *pspec
);

static GstCaps *gst_tox_audio_sink_get_caps(
  GstBaseSink *gst_base_sink,
  GstCaps *filter
);

static gboolean gst_tox_audio_sink_query(
  GstBaseSink *gst_base_sink,
  GstQuery *gst_query
);

static gboolean gst_tox_audio_sink_query_accept_caps(
  GstBaseSink *gst_base_sink,
  GstQuery *gst_query
);

static gboolean gst_tox_audio_sink_open(GstAudioSink *gst_audio_sink);

static gboolean gst_tox_audio_sink_close(GstAudioSink *gst_audio_sink);

static gboolean gst_tox_audio_sink_prepare(
  GstAudioSink *gst_audio_sink,
  GstAudioRingBufferSpec *gst_audio_ring_buffer_spec
);

static gboolean gst_tox_audio_sink_unprepare(GstAudioSink *gst_audio_sink);

static void gst_tox_audio_sink_reset(GstAudioSink *gst_audio_sink);

static guint gst_tox_audio_sink_delay(GstAudioSink *gst_audio_sink);

static gint gst_tox_audio_sink_write(
  GstAudioSink *gst_audio_sink,
  gpointer data,
  guint length
);

/******************************************************************************
 * Variables
 ******************************************************************************/

static GstStaticPadTemplate sink_template = GST_STATIC_PAD_TEMPLATE(
  "sink",
  GST_PAD_SINK,
  GST_PAD_ALWAYS,
  GST_STATIC_CAPS(
    "audio/x-raw, "
    "format = (string) S16LE, "
    "rate = (int) 48000, "
    "channels = (int) 1, "
    "channel-mapping-family = (int) 0, "
    "stream-count = (int) 1, "
    "coupled-count = (int) 0"
  )
);

/******************************************************************************
 * Function implementations
 ******************************************************************************/

void gst_tox_audio_sink_class_init(GstToxAudioSinkClass *const klass)
{
  GST_DEBUG_CATEGORY_INIT(
    gst_tox_audio_sink_debug,
    "toxaudiosink",
    0,
    "toxaudiosink element"
  );

  parent_class = g_type_class_peek_parent(klass);

  // Class inheritance hierarchy

  GObjectClass      *const gobject_class        = (GObjectClass*)klass;
  GstElementClass   *const gst_element_class    = (GstElementClass*)klass;
  GstBaseSinkClass  *const gst_base_sink_class  = (GstBaseSinkClass*)klass;
  GstAudioSinkClass *const gst_audio_sink_class = (GstAudioSinkClass*)klass;

  // GObjectClass

  gobject_class->finalize     = gst_tox_audio_sink_finalize;
  gobject_class->get_property = gst_tox_audio_sink_get_property;
  gobject_class->set_property = gst_tox_audio_sink_set_property;

  g_object_class_install_property(
    gobject_class,
    PROP_TOX_AV,
    g_param_spec_uint64(
      "tox-av",
      "ToxAV",
      "ToxAV instance",
      0,
      UINT64_MAX,
      0,
      G_PARAM_READWRITE
    )
  );

  g_object_class_install_property(
    gobject_class,
    PROP_FRIEND_NUMBER,
    g_param_spec_uint(
      "friend-number",
      "Friend number",
      "Friend number",
      0,
      UINT32_MAX,
      0,
      G_PARAM_READWRITE
    )
  );

  // GstElementClass

  gst_element_class_set_details_simple(
    gst_element_class,
    "ToxAudioSink",
    "Sink/Audio",
    "Sends audio to Tox",
    "Braiden Vasco <braiden-vasco@users.noreply.github.com>"
  );

  gst_element_class_add_pad_template(
    gst_element_class,
    gst_static_pad_template_get(&sink_template)
  );

  // GstBaseSinkClass

  gst_base_sink_class->get_caps = GST_DEBUG_FUNCPTR(gst_tox_audio_sink_get_caps);
  gst_base_sink_class->query    = GST_DEBUG_FUNCPTR(gst_tox_audio_sink_query);

  // GstAudioSinkClass

  gst_audio_sink_class->open      = GST_DEBUG_FUNCPTR(gst_tox_audio_sink_open);
  gst_audio_sink_class->close     = GST_DEBUG_FUNCPTR(gst_tox_audio_sink_close);
  gst_audio_sink_class->prepare   = GST_DEBUG_FUNCPTR(gst_tox_audio_sink_prepare);
  gst_audio_sink_class->unprepare = GST_DEBUG_FUNCPTR(gst_tox_audio_sink_unprepare);
  gst_audio_sink_class->reset     = GST_DEBUG_FUNCPTR(gst_tox_audio_sink_reset);
  gst_audio_sink_class->delay     = GST_DEBUG_FUNCPTR(gst_tox_audio_sink_delay);
  gst_audio_sink_class->write     = GST_DEBUG_FUNCPTR(gst_tox_audio_sink_write);
}

void gst_tox_audio_sink_init(GstToxAudioSink *const self)
{
  self->tox_av = NULL;
  self->friend_number = 0;
}

void gst_tox_audio_sink_finalize(GObject *const object)
{
  G_OBJECT_CLASS(parent_class)->finalize(object);
}

void gst_tox_audio_sink_get_property(
  GObject *const object,
  const guint prop_id,
  GValue *const value,
  GParamSpec *const pspec
)
{
  switch (prop_id) {
    case PROP_TOX_AV:
      g_value_set_uint64(value, (guint64)GST_TOX_AUDIO_SINK(object)->tox_av);
      break;
    case PROP_FRIEND_NUMBER:
      g_value_set_uint(value, GST_TOX_AUDIO_SINK(object)->friend_number);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID(object, prop_id, pspec);
  }
}

void gst_tox_audio_sink_set_property(
  GObject *const object,
  const guint prop_id,
  const GValue *const value,
  GParamSpec *const pspec
)
{
  switch (prop_id) {
    case PROP_TOX_AV:
      GST_TOX_AUDIO_SINK(object)->tox_av = (gpointer)g_value_get_uint64(value);
      break;
    case PROP_FRIEND_NUMBER:
      GST_TOX_AUDIO_SINK(object)->friend_number = g_value_get_uint(value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID(object, prop_id, pspec);
  }
}

GstCaps *gst_tox_audio_sink_get_caps(
  GstBaseSink *gst_base_sink,
  GstCaps *filter
)
{
  GstPad *pad = GST_BASE_SINK_PAD(gst_base_sink);
  return gst_pad_get_pad_template_caps(pad);
}

gboolean gst_tox_audio_sink_query(
  GstBaseSink *gst_base_sink,
  GstQuery *gst_query
)
{
  switch (GST_QUERY_TYPE(gst_query)) {
    case GST_QUERY_ACCEPT_CAPS:
      return gst_tox_audio_sink_query_accept_caps(gst_base_sink, gst_query);
    default:
      return GST_BASE_SINK_CLASS(parent_class)->
               query(gst_base_sink, gst_query);
  }
}

gboolean gst_tox_audio_sink_query_accept_caps(
  GstBaseSink *gst_base_sink,
  GstQuery *gst_query
)
{
  return GST_BASE_SINK_CLASS(parent_class)->query(gst_base_sink, gst_query);
}

gboolean gst_tox_audio_sink_open(GstAudioSink *gst_audio_sink)
{
  return TRUE;
}

gboolean gst_tox_audio_sink_close(GstAudioSink *gst_audio_sink)
{
  return TRUE;
}

gboolean gst_tox_audio_sink_prepare(
  GstAudioSink *gst_audio_sink,
  GstAudioRingBufferSpec *gst_audio_ring_buffer_spec
)
{
  return TRUE;
}

gboolean gst_tox_audio_sink_unprepare(GstAudioSink *gst_audio_sink)
{
  return TRUE;
}

void gst_tox_audio_sink_reset(GstAudioSink *gst_audio_sink)
{
}

guint gst_tox_audio_sink_delay(GstAudioSink *gst_audio_sink)
{
  return 0;
}

gint gst_tox_audio_sink_write(
  GstAudioSink *const gst_audio_sink,
  const gpointer data,
  const guint length
)
{
  const GstToxAudioSink *const gst_tox_audio_sink =
    GST_TOX_AUDIO_SINK(gst_audio_sink);

  if (!gst_tox_audio_sink->tox_av) {
    return length;
  }

  const size_t sample_count = length / sizeof(int16_t);

  TOXAV_ERR_SEND_FRAME toxav_audio_send_frame_error;

  toxav_audio_send_frame(
    gst_tox_audio_sink->tox_av,
    gst_tox_audio_sink->friend_number,
    data,
    sample_count,
    1, // channels
    48000, // sampling_rate
    &toxav_audio_send_frame_error
  );

  return length;
}
