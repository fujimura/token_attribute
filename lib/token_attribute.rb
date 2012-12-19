require File.join(File.dirname(__FILE__), 'token_attribute', 'version')
require 'active_record'
require 'active_support'

module TokenAttribute
  extend ActiveSupport::Concern

  module ClassMethods
    DEFAULT_TOKEN_LENGTH = 10

    # Macro-ish method to define token-setter.
    # #set_#{attribute_name} will be defined to set unique token.
    #
    def token_attribute(*args)
      options = args.extract_options!
      attribute_names = args

      if options[:protected]
        attr_protected *attribute_names
      end

      # `/ 2` because "The length of the result string is twice of n".
      # see: http://www.ruby-doc.org/stdlib-1.9.3/libdoc/securerandom/rdoc/SecureRandom.html#method-c-hex
      raise "Can't set odd number to token length" if options[:length] && (options[:length] % 2) == 1
      length = (options[:length] || DEFAULT_TOKEN_LENGTH) / 2

      attribute_names.each do |attribute|

        generator_method_name = "generate_#{attribute}"

        define_method generator_method_name do
          key = SecureRandom.hex(length)
        end
        scope_items = Array.wrap(options[:scope])

        setter_method_name = "set_#{attribute}"

        define_method setter_method_name do

          key = send generator_method_name

          cond = {}
          scope_items.each do |scope_item|
            cond[scope_item] = self.send(scope_item)
          end
          cond.merge!(attribute => key)

          unless self.class.where(cond).exists?
            self[attribute] = key
          else
            send setter_method_name
          end
        end

      end
    end
  end

end
