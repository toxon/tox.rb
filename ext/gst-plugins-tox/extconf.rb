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

cflags '-std=c11'
cflags '-Wall'
cflags '-Wextra'
cflags '-Wno-declaration-after-statement'

pkg_config! 'gstreamer-1.0'

have_library! 'gstreamer-1.0'

have_header! 'gst/gst.h'

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

have_const! 'gst/gst.h', 'G_PARAM_READWRITE'

have_func! 'gst/gst.h', 'g_object_class_install_property'
have_func! 'gst/gst.h', 'g_param_spec_boolean'
# have_func!' gst/gst.h', 'g_value_get_boolean'
have_func 'gst/gst.h', 'g_value_set_boolean'

have_type! 'gst/gst.h', 'GstObject'
have_type! 'gst/gst.h', 'GstElement'
have_type! 'gst/gst.h', 'GstElementClass'
have_type! 'gst/gst.h', 'GstPad'
have_type! 'gst/gst.h', 'GstStaticPadTemplate'
have_type! 'gst/gst.h', 'GstEvent'
have_type! 'gst/gst.h', 'GstFlowReturn'
have_type! 'gst/gst.h', 'GstBuffer'
have_type! 'gst/gst.h', 'GstCaps'

have_macro! 'gst/gst.h', 'GST_ELEMENT'
have_macro! 'gst/gst.h', 'GST_STATIC_CAPS'
have_macro! 'gst/gst.h', 'GST_TYPE_ELEMENT'
have_macro! 'gst/gst.h', 'GST_DEBUG_FUNCPTR'
have_macro! 'gst/gst.h', 'GST_PAD_SET_PROXY_CAPS'
have_macro! 'gst/gst.h', 'GST_LOG_OBJECT'
have_macro! 'gst/gst.h', 'GST_PTR_FORMAT'
have_macro! 'gst/gst.h', 'GST_EVENT_TYPE_NAME'
have_macro! 'gst/gst.h', 'GST_EVENT_TYPE'

have_const! 'gst/gst.h', 'GST_PAD_SINK'
have_const! 'gst/gst.h', 'GST_PAD_ALWAYS'
have_const! 'gst/gst.h', 'GST_EVENT_CAPS'
have_const! 'gst/gst.h', 'GST_FLOW_OK'

have_func! 'gst/gst.h', 'gst_element_class_set_details_simple'
have_func! 'gst/gst.h', 'gst_element_class_add_pad_template'
have_func! 'gst/gst.h', 'gst_static_pad_template_get'
have_func! 'gst/gst.h', 'gst_pad_new_from_static_template'
# have_func! 'gst/gst.h', 'gst_pad_set_event_function'
# have_func! 'gst/gst.h', 'gst_pad_set_chain_function'
have_func! 'gst/gst.h', 'gst_element_add_pad'
have_func! 'gst/gst.h', 'gst_pad_event_default'
have_func! 'gst/gst.h', 'gst_event_parse_caps'

create_makefile 'gst-plugins-tox' or exit 1
