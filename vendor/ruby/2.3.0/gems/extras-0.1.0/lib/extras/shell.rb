# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "shellwords"

module Extras
  module Shell

    # ------------------------------------------------------------------------
    # rubocop:disable Metrics/CyclomaticComplexity
    # Escapes a string double checking if it will double escape.
    # rubocop:disable Metrics/PerceivedComplexity
    # Note: This is taken from Ruby 2.3 StdLib.
    # ------------------------------------------------------------------------

    def escape(str, original: false)
      if original
        return super(
          str
        )
      end

      if !str || str.empty? || str == '""' || str == "''"
        return '""'

      elsif str.is_a?(Array)
        str.map do |v|
          escape(v)
        end

      elsif str.is_a?(Hash)
        str.each do |k, v|
          str[k] = escape(
            v
          )
        end

      else
        regexp = /((?:\\)?[^A-Za-z0-9_\-.,:\/@\n])/
        str = str.gsub(regexp) { $1.start_with?("\\") ? $1 : "\\#{$1}" }
        str = str.gsub(/\n/, "'\n'")
        str
      end
    end

    alias shellescape escape
  end
end

#

module Shellwords
  class << self
    prepend Extras::Shell
  end
end
