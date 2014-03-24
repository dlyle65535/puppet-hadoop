# spec/classes/init_spec.rb
require 'spec_helper'

describe "hadoop::init" do
  
  
      
	let :default_params do
    {
      :version => '0.20.203.0',
      :master => 'hadoop01',
      :slaves => [hadoop01, hadoop-02, hadoop-03],
      :hdfsport => '8020',
      :replication => '3',
      :jobtrackerport => '8021',
      :java_home => '/foo/jdk0.1.0',
      :hadoop_base => '/opt/hadoop',
      :hdfs_path => '/data/tmp/hadoop-${user.name}',
    }
 	end          
  
  context "CentOS" do
    
     let :facts do
      {
         :osfamily => 'RedHat',
         :operatingsystem => 'CentOS'
      }
    end
       
    it { should contain_class('hadoop::params') }
    
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
  	
  	#core-site.xml
	it do 
		should contain_file('/etc/hadoop-0.20/conf/core-site.xml').with(
			:owner => "hdfs",
			:group => "hadoop",
			:mode => "644",
			:alias => "core-site-xml"
		) 
		should contain_file('/etc/hadoop-0.20/conf/core-site.xml').with_content(/<name>fs.default.name<\/name>\n\t<value>hdfs:\/\/hadoop01:8020/)
		should contain_file('/etc/hadoop-0.20/conf/core-site.xml').with_content(/<name>hadoop.tmp.dir<\/name>\n\t<value>\/data\/tmp\/hadoop\-\$\{user.name\}/)
	end	  		
	
    #hdfs-site.xml
    it do 
		should contain_file('/etc/hadoop-0.20/conf/hdfs-site.xml').with(
			:owner => "hdfs",
			:group => "hadoop",
			:mode => "644",
			:alias => "hdfs-site-xml"
		) 
		should contain_file('/etc/hadoop-0.20/conf/hdfs-site.xml').with_content(/<name>dfs.replication<\/name>\n\t<value>3/)		
	end	  		
	
    #mapred-site.xml
    #hadoop-env.sh    
    
    #maybes
    #fair-secheduler.xml
    #capacity-scheduler.xml
    #ssh-keys
    
	        
  	end #context
  end   
  		

