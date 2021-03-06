# frozen_string_literal: true

module Arli
  module Helpers
    module Inherited

      module ClassMethods
        def set_or_get(var_name, val = nil, set_nil = false)
          var = "@#{var_name}".to_sym
          instance_variable_set(var, val) if val
          instance_variable_set(var, nil) if set_nil
          instance_variable_get(var)
        end

        def short_name
          name.gsub(/.*::/, '').underscore.to_sym
        end

        def attr_assignable(*attrs)
          self.class.instance_eval do
            attrs.each do |attribute|
              send(:define_method, attribute) do |val = nil, **opts|
                set_or_get(attribute, val, opts && opts[:nil])
              end
            end
          end
        end
      end

      module Subclassing
        def included(klass)
          klass.instance_eval do
            class << self
              include ::Arli::Helpers::Inherited
            end
          end
        end
      end

      def self.included(base)
        # This works for both classes and modules
        base.instance_eval do
          class << self
            include(::Arli::Helpers::Inherited::ClassMethods)
          end
        end
        base.extend(Subclassing) if base.is_a?(Class)
      end
    end
  end
end
