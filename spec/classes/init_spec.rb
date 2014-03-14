# spec/classes/init_spec.rb
require 'spec_helper'

describe "hadoop::init" do
  context "CentOS" do
    let :facts do
      {
         :osfamily => 'RedHat',
         :operatingsystem => 'CentOS'
      }
    end
      
    #group
	it { should create_group('hadoop').with_gid('123')  }
	      
	#user	      
    it do should create_user('hdfs').with(
    	'uid' => '102',
    	'ensure' => 'present',
    	'gid' => '124',
		'shell' => '/bin/bash',
		'home' => '/home/hduser',
		'require' => 'Group[hadoop]'	
    	) end    
  end
  
  #verify repo
  

end   
  		

