# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Extras
  module Hash
    module ClassMethods
      def allowed
        @allowed ||= begin
          {
            :keys => [],
            :vals => [::NilClass, ::Hash, ::TrueClass, \
              ::FalseClass, ::Regexp, ::Array, ::Set, ::Fixnum,
              ::Bignum, ::Float]
          }
        end
      end
    end

    # ------------------------------------------------------------------------
    # Symbolize keys and values of the current hash, skipping allowed objects.
    # ------------------------------------------------------------------------

    def symbolize(allowed_keys: nil, allowed_vals: nil)
      keys = allowed_keys || self.class.allowed[:keys]
      vals = allowed_vals || self.class.allowed[:vals]

      each_with_object({}) do |(k, v), h|
        k = k.to_sym unless !k.respond_to?(:to_sym) || keys.include?(k.class)
        v = v.to_sym unless !v.respond_to?(:to_sym) || vals.include?(v.class)

        h[k] = !v.respond_to?(:symbolize) ? v : v.symbolize({
          :allowed_keys => allowed_keys,
          :allowed_vals => allowed_vals
        })
      end
    end

    # ------------------------------------------------------------------------
    # Stringify keys and values of the current hash, skipping objects
    # that are allowed to be skipped (leaving them as is, untouched.)
    # ------------------------------------------------------------------------

    def stringify(allowed_keys: nil, allowed_vals: nil)
      keys = allowed_keys || self.class.allowed[:keys]
      vals = allowed_vals || self.class.allowed[:vals]

      each_with_object({}) do |(k, v), h|
        v = v.to_s if !v.respond_to?(:stringify) && !vals.include?(v.class)
        k = k.to_s unless keys.include?(k.class)

        h[k] = !v.respond_to?(:stringify) ? v : v.stringify({
          :allowed_keys => allowed_keys,
          :allowed_vals => allowed_vals
        })
      end
    end

    # ------------------------------------------------------------------------
    # Stringify the keys of the current hash, skipping allowed objects.
    # ------------------------------------------------------------------------

    def stringify_keys(allowed: nil)
      allowed ||= self.class.allowed[:keys]
      each_with_object({}) do |(k, v), h|
        k = k.to_s unless allowed.include?(k.class)
        h[k] = !v.respond_to?(:stringify_keys) ? v : v.stringify_keys({
          :allowed => allowed
        })
      end
    end

    # ------------------------------------------------------------------------
    # Symbolize the keys of the current hash, skipping allowed objects.
    # ------------------------------------------------------------------------

    def symbolize_keys(allowed: nil)
      allowed ||= self.class.allowed[:keys]
      each_with_object({}) do |(k, v), h|
        k = k.to_sym if k.respond_to?(:to_sym) && !allowed.include?(k.class)
        h[k] = !v.respond_to?(:symbolize_keys) ? v : v.symbolize_keys({
          :allowed => allowed
        })
      end
    end

    # ------------------------------------------------------------------------
    # Merge hash into hash into hash into hash.
    # ------------------------------------------------------------------------

    def deep_merge(new_h)
      merge(new_h) do |_, ov, nv|
        if ov.respond_to?(:deep_merge) && nv.respond_to?(:deep_merge)
          then ov.deep_merge(
            nv
          )

        else
          nv
        end
      end
    end

    # ------------------------------------------------------------------------
    # Check to see if any of the given keys exist.
    # ------------------------------------------------------------------------

    def any_key?(*keys)
      keys.any? do |k|
        key?(k)
      end
    end
  end
end

#

class Hash
  prepend Extras::Hash
  class << self
    prepend Extras::Hash::ClassMethods
  end
end
