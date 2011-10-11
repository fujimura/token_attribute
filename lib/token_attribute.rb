require File.join(File.dirname(__FILE__), 'token_attribute', 'version')
require 'active_record'
require 'active_support'

module TokenAttribute
  extend ActiveSupport::Concern

  module ClassMethods

    # Macro-ish method to define token-setter.
    # #set_#{attribute_name} will be defined to set unique token.
    #
    def token_attribute(*attribute_names)
      attribute_names.each do |attribute|
        generator_method_name = "set_#{attribute}"
        define_method generator_method_name do
          key = generate_random_string
          unless self.class.where(attribute => key).exists?
            self[attribute] = key
          else
            send generator_method_name
          end
        end
      end
    end
  end

  module InstanceMethods

    # Generate random string
    #
    def generate_random_string
      SecureRandom.hex(10)
    end
  end
end
