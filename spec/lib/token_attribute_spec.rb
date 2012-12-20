require 'spec_helper'

describe TokenAttribute do

  before do
    User.new # OMG
  end


  describe '.token_attribute' do
    context 'given multiple attributes' do
      subject do
        define_new_class_instance_for User do
          include TokenAttribute
          token_attribute :download_ticket, :password_recovery
        end
      end

      it 'can token_attribute-ize multiple attributes' do
        [:download_ticket, :password_recovery].each do |a|
          method_name = ('set_' + a.to_s).to_sym
          subject.new.methods.map(&:to_sym).should include method_name
        end
      end
    end

    context 'with :protected => true' do
      subject do
        define_new_class_instance_for User do
          include TokenAttribute
          token_attribute :download_ticket, :protected => true
        end
      end

      it 'should protect attribute' do
        subject.protected_attributes.should include :download_ticket
      end
    end

    context 'with scope' do
      subject do
        define_new_class_instance_for User do
          include TokenAttribute
          token_attribute :download_ticket, :scope => :name
          before_save :set_download_ticket
        end
      end

      it 'assign token attribute with given scope' do
        one = subject.new :name => 'fujimura'
        two = subject.new :name => 'tanaka'
        [one, two].each {|u| u.stub(:generate_download_ticket).and_return 'a' }
        [one, two].each {|u| u.save }
        one.download_ticket.should == two.download_ticket
      end
    end

    describe 'Token length' do
      context 'default' do
        subject do
          define_new_class_instance_for User do
            include TokenAttribute
            token_attribute :download_ticket
            before_save :set_download_ticket
          end
        end

        specify do
          one = subject.new :name => 'fujimura'
          one.save
          one.download_ticket.length.should == 10
        end
      end

      context 'set to 8' do
        subject do
          define_new_class_instance_for User do
            include TokenAttribute
            token_attribute :download_ticket, :length => 8
            before_save :set_download_ticket
          end
        end

        specify do
          one = subject.new :name => 'fujimura'
          one.save
          one.download_ticket.length.should == 8
        end
      end
    end
  end

  context 'class with access_token as token_attribute' do
    let(:user) { User.new }

    after do
      User.delete_all
    end

    describe '#generate_access_token' do
      it 'returns random string' do
        SecureRandom.stub(:hex).and_return 'abcde'
        user.generate_access_token.should == 'abcde'
      end
    end

    describe '#set_access_token' do
      it 'sets access_token' do
        user.set_access_token
        user.access_token.should_not be_nil
      end

      context 'when User with same token already exists' do
        let(:token) { 'duplicating' }
        before do
          User.create :access_token => token
        end

        it 'set again' do
          user.stub(:generate_access_token).and_return token
          user.should_receive(:generate_access_token).and_return token + 'a'
          user.set_access_token
        end
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
