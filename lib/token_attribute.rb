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
        setter_method_name    = "set_#{attribute}"
        attribute_to_scope    = Array.wrap(options[:scope])

        define_method generator_method_name do
          key = SecureRandom.hex(length)
        end

        define_method setter_method_name do

          candidate = send generator_method_name

          # Gererate scope condition
          condition = {}
          attribute_to_scope.each do |name|
            condition[name] = self.attributes[name]
          end
          condition.merge!(attribute => candidate)

          unless self.class.where(condition).exists?
            self[attribute] = candidate
          else
            # Recur if the token is already used
            send setter_method_name
          end
        end

      end
    end
  end

end
