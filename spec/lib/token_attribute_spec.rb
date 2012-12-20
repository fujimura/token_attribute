require 'spec_helper'

describe TokenAttribute do

  before do
    @user = User.new
  end

  after do
    User.delete_all
  end

  describe '.token_attribute' do
    it 'can token_attribute-ize multiple attributes' do
      klass = User.dup
      klass.class_eval do
        include TokenAttribute
        token_attribute :download_ticket, :password_recovery
      end
      [:download_ticket, :password_recovery].each do |a|
        method_name = ('set_' + a.to_s).to_sym
        klass.new.methods.map(&:to_sym).should include method_name
      end
    end

    it 'can make attr_protected with option' do
      klass = User.dup
      klass.class_eval do
        include TokenAttribute
        token_attribute :download_ticket, :protected => true
      end
      klass.protected_attributes.should include :download_ticket
    end

    it 'can scope' do
      klass = User.dup
      klass.class_eval do
        include TokenAttribute
        token_attribute :download_ticket, :scope => :name
        before_save :set_download_ticket
      end
      one = klass.new :name => 'fujimura'
      two = klass.new :name => 'tanaka'
      [one, two].each {|u| u.stub(:generate_download_ticket).and_return 'a' }
      [one, two].each {|u| u.save }
      one.download_ticket.should == two.download_ticket
    end

    describe 'Token length' do
      it '10 by default' do
        klass = User.dup
        klass.class_eval do
          include TokenAttribute
          token_attribute :download_ticket
          before_save :set_download_ticket
        end
        one = klass.new :name => 'fujimura'
        one.save
        one.download_ticket.length.should == 10
      end

      it 'can be configured' do
        klass = User.dup
        klass.class_eval do
          include TokenAttribute
          token_attribute :download_ticket, :length => 8
          before_save :set_download_ticket
        end
        one = klass.new :name => 'fujimura'
        one.save
        one.download_ticket.length.should == 8
      end
    end
  end

  context 'class with access_token as token_attribute' do

    describe '#generate_access_token' do
      it 'returns random string' do
        SecureRandom.stub(:hex).and_return 'abcde'
        @user.generate_access_token.should == 'abcde'
      end
    end

    describe '#set_access_token' do
      it 'sets access_token' do
        @user.set_access_token
        @user.access_token.should_not be_nil
      end

      it 'set again if it duplicates' do
        dup = 'duplicating'
        User.create :access_token => dup
        uniq = 'notduplicating'
        @user.should_receive(:generate_access_token).and_return dup
        @user.should_receive(:generate_access_token).and_return uniq
        @user.set_access_token
      end
    end

  end

  describe 'class with its own random string generator' do
    it 'will use it instead of TokenAttribute#generate_random_string' do
      coupon = Coupon.new
      coupon.set_code
      coupon.code.should == 'my code'
    end
  end
end
