# frozen_string_literal: true

module Tox
  ##
  # Video frame.
  #
  class VideoFrame
    using CoreExt

    attr_reader :y_plane, :u_plane, :v_plane

    def initialize
      @y_plane = ''
      @u_plane = ''
      @v_plane = ''
    end

    def y_plane=(value)
      String.ancestor_of! value
      @y_plane = value
    end

    def u_plane=(value)
      String.ancestor_of! value
      @u_plane = value
    end

    def v_plane=(value)
      String.ancestor_of! value
      @v_plane = value
    end
  end
end
