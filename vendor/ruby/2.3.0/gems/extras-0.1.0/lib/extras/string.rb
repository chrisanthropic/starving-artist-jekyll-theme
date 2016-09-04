# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "forwardable/extended"

module Extras
  module String
    extend Forwardable::Extended
    rb_delegate :regexp_escape, {
      :alias_of => :escape,
      :to => Regexp,
      :args => [
        :self
      ]
    }

    # ------------------------------------------------------------------------
    # Note: This method has support for "\char" escaping to prevent splits.
    # Split a string into an array.
    # ------------------------------------------------------------------------

    def to_a(char: "\s", strip: true)
      escaped = char.regexp_escape
      split(/(?<!\\)#{escaped}/).map do |v|
        strip ? v.gsub(/\\#{escaped}/, char) : v
      end
    end
  end
end

class String
  prepend Extras::String
end
