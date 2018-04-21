#ifndef __GST_TOXSINK_H__
#define __GST_TOXSINK_H__

#include <gst/gst.h>

#define GST_TYPE_TOXSINK \
  (get_tox_sink_get_type())

#define GST_TOXSINK(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_TOXSINK,GstToxSink))

#define GST_TOXSINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_TOXSINK,GetToxSinkClass))

#define GST_IS_TOXSINK(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_TOXSINK))

#define GST_IS_TOXSINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_TOXSINK))

typedef struct _GstToxSink      GstToxSink;
typedef struct _GstToxSinkClass GstToxSinkClass;

struct _GstToxSink {
  GstElement element;

  GstPad *sinkpad;

  gboolean silent;
};

struct _GstToxSinkClass {
  GstElementClass parent_class;
};

GType get_tox_sink_get_type();

#endif // __GST_TOXSINK_H__

enum {
  PROP_0,
  PROP_SILENT
};

static GstStaticPadTemplate sink_factory = GST_STATIC_PAD_TEMPLATE(
  "sink",
  GST_PAD_SINK,
  GST_PAD_ALWAYS,
  GST_STATIC_CAPS("ANY")
);

#define gst_tox_sink_parent_class parent_class
G_DEFINE_TYPE(GstToxSink, gst_tox_sink, GST_TYPE_ELEMENT);

static void gst_tox_sink_class_init(GstToxSinkClass *klass);

static void gst_tox_sink_init(GstToxSink *element);

static void gst_tox_sink_set_property(
  GObject *object,
  guint prop_id,
  const GValue *value,
  GParamSpec *pspec
);

static void gst_tox_sink_get_property(
  GObject *object,
  guint prop_id,
  GValue *value,
  GParamSpec *pspec
);

static gboolean gst_tox_sink_sink_event(
  GstPad *pad,
  GstObject *parent,
  GstEvent *event
);

static GstFlowReturn gst_tox_sink_chain(
  GstPad *pad,
  GstObject *parent,
  GstBuffer *buffer
);

void gst_tox_sink_class_init(GstToxSinkClass *const klass)
{
  GObjectClass    *const gobject_class     = (GObjectClass*)klass;
  GstElementClass *const gst_element_class = (GstElementClass*)klass;

  gobject_class->set_property = gst_tox_sink_set_property;
  gobject_class->get_property = gst_tox_sink_get_property;

  g_object_class_install_property(
    gobject_class,
    PROP_SILENT,
    g_param_spec_boolean("silent", "Silent", "Produce verbose output?",
                         FALSE, G_PARAM_READWRITE)
  );

  gst_element_class_set_details_simple(
    gst_element_class,
    "ToxSink",
    "Generic",
    "Sends Opus audio to Tox",
    "Braiden Vasco <braiden-vasco@users.noreply.github.com>"
  );

  gst_element_class_add_pad_template(
    gst_element_class, gst_static_pad_template_get(&sink_factory)
  );
}

void gst_tox_sink_init(GstToxSink *const element)
{
  element->sinkpad = gst_pad_new_from_static_template(&sink_factory, "sink");

  gst_pad_set_event_function(element->sinkpad,
                             GST_DEBUG_FUNCPTR(gst_tox_sink_sink_event));

  gst_pad_set_chain_function(element->sinkpad,
                             GST_DEBUG_FUNCPTR(gst_tox_sink_chain));

  GST_PAD_SET_PROXY_CAPS(element->sinkpad);

  gst_element_add_pad(GST_ELEMENT(element), element->sinkpad);

  element->silent = FALSE;
}

void gst_tox_sink_set_property(
  GObject *const object,
  const guint prop_id,
  const GValue *const value,
  GParamSpec *const pspec
)
{
  GstToxSink *const element = GST_TOXSINK(object);

  switch (prop_id) {
    case PROP_SILENT:
      element->silent = g_value_get_boolean(value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID(object, prop_id, pspec);
  }
}

void gst_tox_sink_get_property(
  GObject *const object,
  const guint prop_id,
  GValue *const value,
  GParamSpec *const pspec
)
{
  GstToxSink *const element = GST_TOXSINK(object);

  switch (prop_id) {
    case PROP_SILENT:
      g_value_set_boolean(value, element->silent);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID(object, prop_id, pspec);
  }
}

gboolean gst_tox_sink_sink_event(
  GstPad *const pad,
  GstObject *const parent,
  GstEvent *const event
)
{
  GstToxSink *element = GST_TOXSINK(parent);

  GST_LOG_OBJECT(
    element,
    "Received %s event: %" GST_PTR_FORMAT,
    GST_EVENT_TYPE_NAME(event),
    event
  );

  switch (GST_EVENT_TYPE(event)) {
    case GST_EVENT_CAPS:
    {
      GstCaps *caps;
      gst_event_parse_caps(event, &caps);
      // TODO: do something with the caps
      return gst_pad_event_default(pad, parent, event);
    }
    default:
      return gst_pad_event_default(pad, parent, event);
  }
}

GstFlowReturn gst_tox_sink_chain(
  GstPad *const pad,
  GstObject *const parent,
  GstBuffer *const buffer
)
{
  return GST_FLOW_OK;
}
