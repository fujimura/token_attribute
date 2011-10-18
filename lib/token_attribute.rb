require File.join(File.dirname(__FILE__), 'token_attribute', 'version')
require 'active_record'
require 'active_support'

module TokenAttribute
  extend ActiveSupport::Concern

  module ClassMethods

    # Macro-ish method to define token-setter.
    # #set_#{attribute_name} will be defined to set unique token.
    #
    def token_attribute(*args)
      options = args.extract_options!
      attribute_names = args

      if options[:protected]
        attr_protected *attribute_names
      end

      attribute_names.each do |attribute|

        generator_method_name = "generate_#{attribute}"

        define_method generator_method_name do
          key = SecureRandom.hex(10)
        end

        setter_method_name = "set_#{attribute}"

        define_method setter_method_name do
          key = send generator_method_name
          unless self.class.where(attribute => key).exists?
            self[attribute] = key
          else
            send setter_method_name
          end
        end

      end
    end
  end

end
