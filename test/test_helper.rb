require 'rubygems'
require File.expand_path('../../lib/token_attribute', __FILE__)
require 'minitest/unit'
require 'contest'
require 'rr'
require 'ruby-debug'
require 'turn'
Test::Unit::TestCase.send :include, RR::Adapters::TestUnit

ActiveRecord::Base.configurations = {
  'test' => {
    :adapter => 'sqlite3',
    :database => ':memory:'
  }
}
ActiveRecord::Base.establish_connection('test')

class User < ActiveRecord::Base
  include TokenAttribute
  token_attribute :access_token
end

class Coupon < ActiveRecord::Base
  include TokenAttribute
  token_attribute :code
  def generate_code
    'my code'
  end
end

class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string "name"
      t.string "access_token"
      t.string "download_ticket"
      t.string "password_recovery"
    end
    create_table(:coupons) do |t|
      t.string "code"
    end
  end
end

CreateAllTables.up
