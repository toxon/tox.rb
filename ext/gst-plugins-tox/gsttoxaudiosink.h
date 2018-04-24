#ifndef __GSTTOXAUDIOSINK_H__
#define __GSTTOXAUDIOSINK_H__

#include <gst/gst.h>
#include <gst/audio/gstaudiosink.h>

#define GST_TYPE_TOX_AUDIO_SINK \
  (gst_tox_audio_sink_get_type())

#define GST_TOX_AUDIO_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_TOX_AUDIO_SINK,GstToxAudioSink))

#define GST_TOX_AUDIO_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_TOX_AUDIO_SINK,GetToxAudioSinkClass))

#define GST_IS_TOX_AUDIO_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_TOX_AUDIO_SINK))

#define GST_IS_TOX_AUDIO_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_TOX_AUDIO_SINK))

typedef struct _GstToxAudioSink      GstToxAudioSink;
typedef struct _GstToxAudioSinkClass GstToxAudioSinkClass;

struct _GstToxAudioSink {
  GstAudioSink parent;
};

struct _GstToxAudioSinkClass {
  GstAudioSinkClass parent_class;
};

GType gst_tox_audio_sink_get_type();

#endif // __GSTTOXAUDIOSINK_H__
