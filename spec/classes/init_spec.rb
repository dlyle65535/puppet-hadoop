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
    	
	it do should create_package('hadoop-0.20').with(
    	'ensure' => 'present',
    	'name' => 'hadoop-0.20'
		) end	  
  
	it do should create_package('hadoop-0.20-native').with(
    	'ensure' => 'present',
    	'name' => 'hadoop-0.20-native'
		) end	  
 	
  	#verify repo
  	#verify files	
  	end #context
  
  

end   
  		

