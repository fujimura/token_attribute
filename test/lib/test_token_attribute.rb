require File.expand_path('../../test_helper', __FILE__)

class TokenAttributeTest < Test::Unit::TestCase

  setup do
    @user = User.new
  end

  teardown do
    User.delete_all
  end

  describe '.tokenize' do
    test 'can tokenize multiple attributes' do
      klass = User.dup
      klass.send :include, TokenAttribute
      klass.send :tokenize, :download_ticket, :password_recovery
      [:download_ticket, :password_recovery].each do |a|
        method_name = ('generate_' + a.to_s).to_sym
        assert klass.new.methods.include? method_name
      end
    end
  end

  describe '#generate_access_token' do
    test 'generate identifier' do
      @user.generate_access_token
      assert @user.access_token != nil
    end
    test 'generate again if it duplicates' do
      dup = 'duplicating'
      User.create :access_token => dup
      uniq = 'notduplicating'
      mock(@user).generate_key.times(1) { dup }
      mock(@user).generate_key.times(1) { uniq }
      @user.generate_access_token
    end
  end
  
end
