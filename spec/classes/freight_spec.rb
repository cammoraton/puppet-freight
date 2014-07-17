require 'spec_helper'

describe 'freight', :type => :class do
  context "on an Ubuntu OS" do
    let :facts do
      { :operatingsystem        => 'Ubuntu',
        :lsbdistcodename        => 'trusty',
        :osfamily               => 'Debian',
        :operatingsystemrelease => '14.04',
        :concat_basedir         => '/tmp', }
    end
    let :params do
      {
        
      }
    end
    it { should contain_package("freight") }
    it { should contain_apt_source("freight") }
  end
end