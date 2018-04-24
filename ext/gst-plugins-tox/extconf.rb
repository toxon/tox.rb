#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mkmf'

def cflags(str)
  $CFLAGS += " #{str} "
end

def pkg_config!(*args)
  exit 1 unless pkg_config(*args)
end

def have_library!(*args)
  exit 1 unless have_library(*args)
end

def have_header!(*args)
  exit 1 unless have_header(*args)
end

def have_struct_member!(header, *args)
  exit 1 unless have_struct_member(*args, header)
end

def have_func!(header, *args)
  exit 1 unless have_func(*args, header)
end

def have_macro!(header, *args)
  exit 1 unless have_macro(*args, header)
end

def have_type!(header, *args)
  exit 1 unless have_type(*args, header)
end

def have_const!(header, *args)
  exit 1 unless have_const(*args, header)
end

##########
# Common #
##########

cflags '-std=c11'
cflags '-Wall'
cflags '-Wextra'
cflags '-Wno-declaration-after-statement'

pkg_config! 'gstreamer-1.0'
pkg_config! 'gstreamer-audio-1.0'

have_library! 'toxav'
have_library! 'gstreamer-1.0'
have_library! 'gstaudio-1.0'

have_header! 'tox/tox.h'
have_header! 'gst/gst.h'
have_header! 'gst/base/gstbasesink.h'
have_header! 'gst/audio/gstaudiosink.h'

#########
# ToxAV #
#########

have_func! 'tox/toxav.h', 'toxav_audio_send_frame'

########
# GLib #
########

have_type! 'gst/gst.h', 'gpointer'
have_type! 'gst/gst.h', 'gboolean'
have_type! 'gst/gst.h', 'guint'
have_type! 'gst/gst.h', 'GValue'
have_type! 'gst/gst.h', 'GObject'
have_type! 'gst/gst.h', 'GType'
have_type! 'gst/gst.h', 'GParamSpec'
have_type! 'gst/gst.h', 'GObjectClass'

have_macro! 'gst/gst.h', 'G_TYPE_CHECK_INSTANCE_CAST'
have_macro! 'gst/gst.h', 'G_TYPE_CHECK_CLASS_CAST'
have_macro! 'gst/gst.h', 'G_TYPE_CHECK_INSTANCE_TYPE'
have_macro! 'gst/gst.h', 'G_TYPE_CHECK_CLASS_TYPE'
have_macro! 'gst/gst.h', 'G_DEFINE_TYPE'
have_macro! 'gst/gst.h', 'G_OBJECT_WARN_INVALID_PROPERTY_ID'

have_struct_member! 'gst/gst.h', 'GObjectClass', 'get_property'
have_struct_member! 'gst/gst.h', 'GObjectClass', 'set_property'

have_func! 'gst/gst.h', 'g_type_class_peek_parent'

#############
# GStreamer #
#############

have_type! 'gst/gst.h', 'GstElementClass'
have_type! 'gst/gst.h', 'GstStaticPadTemplate'
have_type! 'gst/gst.h', 'GstPad'
have_type! 'gst/gst.h', 'GstCaps'
# have_type! 'gst/gst.h', 'GstPlugin'

have_type! 'gst/base/gstbasesink.h', 'GstBaseSink'
have_type! 'gst/base/gstbasesink.h', 'GstBaseSinkClass'

have_struct_member! 'gst/base/gstbasesink.h', 'GstBaseSinkClass', 'get_caps'

have_macro! 'gst/gst.h', 'GST_VERSION_MAJOR'
have_macro! 'gst/gst.h', 'GST_VERSION_MINOR'
have_macro! 'gst/gst.h', 'GST_PLUGIN_DEFINE'
have_macro! 'gst/gst.h', 'GST_DEBUG_CATEGORY_STATIC'
have_macro! 'gst/gst.h', 'GST_DEBUG_CATEGORY_INIT'
have_macro! 'gst/gst.h', 'GST_STATIC_CAPS'
have_macro! 'gst/gst.h', 'GST_DEBUG_FUNCPTR'
# have_macro! 'gst/gst.g', 'GST_STATIC_PAD_TEMPLATE'

have_macro! 'gst/base/gstbasesink.h', 'GST_BASE_SINK_PAD'

have_const! 'gst/gst.h', 'GST_PAD_SINK'
have_const! 'gst/gst.h', 'GST_PAD_ALWAYS'
have_const! 'gst/gst.h', 'GST_RANK_NONE'

have_func! 'gst/gst.h', 'gst_element_class_set_details_simple'
have_func! 'gst/gst.h', 'gst_element_register'
have_func! 'gst/gst.h', 'gst_element_class_add_pad_template'
have_func! 'gst/gst.h', 'gst_static_pad_template_get'
have_func! 'gst/gst.h', 'gst_pad_get_pad_template_caps'

###################
# GStreamer Audio #
###################

have_macro! 'gst/audio/gstaudiosink.h', 'GST_TYPE_AUDIO_SINK'

have_type! 'gst/audio/gstaudiosink.h', 'GstAudioSink'
have_type! 'gst/audio/gstaudiosink.h', 'GstAudioSinkClass'

have_struct_member! 'gst/audio/gstaudiosink.h', 'GstAudioSinkClass', 'open'
have_struct_member! 'gst/audio/gstaudiosink.h', 'GstAudioSinkClass', 'prepare'
have_struct_member! 'gst/audio/gstaudiosink.h', 'GstAudioSinkClass', 'unprepare'
have_struct_member! 'gst/audio/gstaudiosink.h', 'GstAudioSinkClass', 'close'
have_struct_member! 'gst/audio/gstaudiosink.h', 'GstAudioSinkClass', 'write'
have_struct_member! 'gst/audio/gstaudiosink.h', 'GstAudioSinkClass', 'reset'
have_struct_member! 'gst/audio/gstaudiosink.h', 'GstAudioSinkClass', 'delay'

##########
# Common #
##########

create_makefile 'gst-plugins-tox' or exit 1
