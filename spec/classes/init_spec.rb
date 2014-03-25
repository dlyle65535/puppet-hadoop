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
       
    it { should contain_class('hadoop::params') }
    #it { should contain_class('repos') }
    
    #group
	it { should create_group('hadoop').with_gid('123')  }
	      
	#user	      
    it do should create_user('hdfs').with(
    	:uid => '102',
    	:ensure => 'present',
    	:gid => '124',
		:shell => '/bin/bash',
		:home => '/home/hduser',
		:require => 'Group[hadoop]'	
    	) end  
    	
	it do should create_package('hadoop-0.20').with(
    	:ensure => 'present',
    	:name => 'hadoop-0.20'
		) end	  
  
	it do should create_package('hadoop-0.20-native').with(
    	:ensure => 'present',
    	:name => 'hadoop-0.20-native'
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
	it do 
		should contain_file('/etc/hadoop-0.20/conf/mapred-site.xml').with(
			:owner => "hdfs",
			:group => "hadoop",
			:mode => "644",
			:alias => "mapred-site-xml"
		) 
		should contain_file('/etc/hadoop-0.20/conf/mapred-site.xml').with_content(/<name>mapred.job.tracker<\/name>\n\t<value>hadoop01:8021/)		
		should contain_file('/etc/hadoop-0.20/conf/mapred-site.xml').with_content(/<name>mapreduce.jobtracker.http.address<\/name>\n\t<value>hadoop01:8022/)
	end	  		
    #hadoop-env.sh    
    it do 
		should contain_file('/etc/hadoop-0.20/conf/hadoop-env.sh').with(
			:owner => "hdfs",
			:group => "hadoop",
			:mode => "644",
			:alias => "hadoop-env-sh"
		) 
		should contain_file('/etc/hadoop-0.20/conf/hadoop-env.sh').with_content(/export JAVA_HOME=\/jdk/)		
	end	  		
	
    #maybes
    #fair-secheduler.xml
    #capacity-scheduler.xml
    #ssh-keys
    
	        
  	end #context
  end   
  		

