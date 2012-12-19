require File.expand_path('../../test_helper', __FILE__)

class TokenAttributeTest < Test::Unit::TestCase

  setup do
    @user = User.new
  end

  teardown do
    User.delete_all
  end

  describe '.token_attribute' do
    test 'can token_attribute-ize multiple attributes' do
      klass = User.dup
      klass.class_eval do
        include TokenAttribute
        token_attribute :download_ticket, :password_recovery
      end
      [:download_ticket, :password_recovery].each do |a|
        method_name = ('set_' + a.to_s).to_sym
        assert klass.new.methods.map(&:to_sym).include? method_name
      end
    end

    test 'can make attr_protected with option' do
      klass = User.dup
      klass.class_eval do
        include TokenAttribute
        token_attribute :download_ticket, :protected => true
      end
      assert klass.protected_attributes.include? :download_ticket
    end

    test 'can scope' do
      klass = User.dup
      klass.class_eval do
        include TokenAttribute
        token_attribute :download_ticket, :scope => :name
        before_save :set_download_ticket
      end
      one = klass.new :name => 'fujimura'
      two = klass.new :name => 'tanaka'
      [one, two].each {|u| stub(u).generate_download_ticket.once { 'a' } }
      [one, two].each {|u| u.save }
      assert one.download_ticket == two.download_ticket
    end

    describe 'Token length' do
      test '10 by default' do
        klass = User.dup
        klass.class_eval do
          include TokenAttribute
          token_attribute :download_ticket
          before_save :set_download_ticket
        end
        one = klass.new :name => 'fujimura'
        one.save
        assert_equal one.download_ticket.length, 10
      end

      test 'can be configured' do
        klass = User.dup
        klass.class_eval do
          include TokenAttribute
          token_attribute :download_ticket, :length => 8
          before_save :set_download_ticket
        end
        one = klass.new :name => 'fujimura'
        one.save
        assert_equal one.download_ticket.length, 8
      end
    end
  end

  context 'class with access_token as token_attribute' do

    describe '#generate_access_token' do
      test 'returns random string' do
        stub(SecureRandom).hex { 'abcde' }
        assert_equal @user.generate_access_token, 'abcde'
      end
    end

    describe '#set_access_token' do
      test 'sets access_token' do
        @user.set_access_token
        assert @user.access_token != nil
      end

      test 'set again if it duplicates' do
        dup = 'duplicating'
        User.create :access_token => dup
        uniq = 'notduplicating'
        mock(@user).generate_access_token.times(1) { dup }
        mock(@user).generate_access_token.times(1) { uniq }
        @user.set_access_token
      end
    end

  end

  describe 'class with its own random string generator' do
    test 'will use it instead of TokenAttribute#generate_random_string' do
      coupon = Coupon.new
      coupon.set_code
      assert coupon.code == 'my code'
    end
  end
end
