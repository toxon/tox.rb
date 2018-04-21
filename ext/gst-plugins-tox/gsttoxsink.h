#ifndef __GST_TOXSINK_H__
#define __GST_TOXSINK_H__

#include <gst/gst.h>

#include "config.h"

#define GST_TYPE_TOXSINK \
  (gst_tox_sink_get_type())

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
