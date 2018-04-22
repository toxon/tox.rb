#include "gsttoxaudiosink.h"

#ifndef PACKAGE
#define PACKAGE "tox"
#endif

static gboolean tox_init(GstPlugin *plugin);

GST_PLUGIN_DEFINE(
  GST_VERSION_MAJOR,
  GST_VERSION_MINOR,
  tox,
  "Tox audio/video sink/src",
  tox_init,
  "0.0.0",
  "GPL",
  "gst-plugins-tox",
  "https://github.com/toxon/tox.rb"
)

gboolean tox_init(GstPlugin *const plugin)
{
  gst_element_register(
    plugin,
    "toxaudiosink",
    GST_RANK_NONE,
    GST_TYPE_TOXAUDIOSINK
  );

  return TRUE;
}
