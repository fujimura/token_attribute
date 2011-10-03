require File.expand_path('../../lib/token_attribute', __FILE__)
require 'test/unit'
require 'contest'
require 'rr'
require 'ruby-debug'
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
  tokenize :access_token
end

class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string "access_token"
      t.string "download_ticket"
      t.string "password_recovery"
    end
  end
end

CreateAllTables.up unless ActiveRecord::Base.connection.table_exists? 'users'
