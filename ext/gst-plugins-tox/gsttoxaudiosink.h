#ifndef __GST_TOXAUDIOSINK_H__
#define __GST_TOXAUDIOSINK_H__

#include <gst/gst.h>

#include "config.h"

#define GST_TYPE_TOXAUDIOSINK \
  (gst_tox_sink_get_type())

#define GST_TOXAUDIOSINK(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_TOXAUDIOSINK,GstToxAudioSink))

#define GST_TOXAUDIOSINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_TOXAUDIOSINK,GetToxAudioSinkClass))

#define GST_IS_TOXAUDIOSINK(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_TOXAUDIOSINK))

#define GST_IS_TOXAUDIOSINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_TOXAUDIOSINK))

typedef struct _GstToxAudioSink      GstToxAudioSink;
typedef struct _GstToxAudioSinkClass GstToxAudioSinkClass;

struct _GstToxAudioSink {
  GstElement element;

  GstPad *sinkpad;

  gboolean silent;
};

struct _GstToxAudioSinkClass {
  GstElementClass parent_class;
};

GType get_tox_sink_get_type();

#endif // __GST_TOXAUDIOSINK_H__
