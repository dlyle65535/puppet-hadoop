# spec/classes/init_spec.rb
require 'spec_helper'

describe "hadoop::init" do
  
  context "CentOS" do
    
     let :facts do
      {
         :osfamily => 'RedHat',
         :operatingsystem => 'CentOS',        
      }
    end
	       	
	
    it { should contain_class('hadoop::params') }
    #it { should contain_class('repos') }
    
    #group
	it { should create_group('hadoop').with_gid('123')  }
	      
	#user	      
    it { should create_user('hdfs').with(
			:uid => '102',
			:ensure => 'present',
			:gid => '124',
			:shell => '/bin/bash',
			:home => '/home/hduser',
			:require => 'Group[hadoop]'	
    	) }  
    	
	it { should create_package('hadoop-0.20').with(
    	:ensure => 'present',
    	:name => 'hadoop-0.20'
		) }	  
  
	it { should create_package('hadoop-0.20-native').with(
    	:ensure => 'present',
    	:name => 'hadoop-0.20-native'
		) }	  
 	
 	
  	#verify repo
  	
  	#verify files
  	
  	#core-site.xml
		it { 
		   should contain_file('/etc/hadoop-0.20/conf/core-site.xml').with(
				:owner => "hdfs",
				:group => "hadoop",
				:mode => "644",
				:alias => "core-site-xml"
			).with_content(
			  /<name>fs.default.name<\/name>\n\t<value>hdfs:\/\/hadoop01:8020/		  
			).with_content(
			  /<name>io.file.buffer.size<\/name>\n\t<value>131072/
			).with_content(
			  /<name>hadoop.tmp.dir<\/name>\n\t<value>\/data\/tmp\/hadoop\-\$\{user.name\}/
			).with_content(
			  /<name>webinterface.private.actions<\/name>\n\t<value>false/
			).with_content(
			  /<name>io.compression.codecs<\/name>\n\t<value>com.hadoop.compression.lzo.LzopCodec/
			).with_content(
			  /<name>io.compression.codec.lzo.class<\/name>\n\t<value>com.hadoop.compression.lzo.LzoCodec/
			).with_content(
			  /<name>mapred.compress.map.output<\/name>\n\t<value>true/
			).with_content(
			  /<name>topology.script.file.name<\/name>\n\t<value><\/value>/
			).with_content(
			  /<name>hadoop.proxyuser.oozie.hosts<\/name>\n\t<value>\*/
			).with_content(
			  /<name>hadoop.proxyuser.oozie.groups<\/name>\n\t<value>\*/
			)
		
		}

	
    #hdfs-site.xml
    it {
			should contain_file('/etc/hadoop-0.20/conf/hdfs-site.xml').with(
				:owner => "hdfs",
				:group => "hadoop",
				:mode => "644",
				:alias => "hdfs-site-xml"
			).with_content(
			  /<name>dfs.replication<\/name>\n\t<value>3/
			)		
	}  		
	
    #mapred-site.xml
	it { 
		should contain_file('/etc/hadoop-0.20/conf/mapred-site.xml').with(
			:owner => "hdfs",
			:group => "hadoop",
			:mode => "644",
			:alias => "mapred-site-xml"
		).with_content(
		  /<name>mapred.job.tracker<\/name>\n\t<value>hadoop01:8021/
		).with_content(
		  /<name>mapreduce.jobtracker.http.address<\/name>\n\t<value>hadoop01:8022/
		)			
	}		
	
	#hadoop-env.sh    
	it { 
		should contain_file('/etc/hadoop-0.20/conf/hadoop-env.sh').with(
			:owner => "hdfs",
			:group => "hadoop",
			:mode => "644",
			:alias => "hadoop-env-sh"
		).with_content(
		  /export JAVA_HOME=\/jdk/
		).with_content(
		  /export HADOOP_HEAPSIZE=1000/
		).with_content(
		  /export HADOOP_JOBTRACKER_OPTS=-Xmx4g/
		).with_content(
		  /export HADOOP_NAMENODE_OPTS=-Xmx4g/
		).with_content(
		  /export HADOOP_SECONDARYNAMENODE_OPTS=-Xmx4g/
		)
	}	  		
	
    #maybes
    #fair-secheduler.xml
    #capacity-scheduler.xml
    #ssh-keys
    
	        
  	end #context
  	
  	context 'Override All Default Values' do

	     let :facts do
	      {
					:osfamily => 'RedHat',
					:operatingsystem => 'CentOS',
					:hadoop_node_version => '1.1.1',
					:hadoop_node_master => 'master',
					:hadoop_node_hdfsport => '1111',
					:hadoop_node_replication => '10',
					:hadoop_node_jobtrackerport => '1337',
					:hadoop_node_hadoop_base => '/base',
					:hadoop_node_java_home =>'/java/home',				
					:hadoop_file_buffer_size => '20',
					:hadoop_tmp_dir => '/tmp/dir',
					:hadoop_enable_private_actions => 'noWayMan',
					:hadoop_compression_codecs => 'a,b,c',
					:hadoop_lzo_class => 'lzoClass',
					:hadoop_compress_map_output => 'Okay',
					:hadoop_topology_script_file_name => 'topologyfile',
					:hadoop_oozie_hosts => 'ooziehosts.com',
					:hadoop_oozie_groups => 'ooziegroups',
					:hadoop_node_job_tracker_http_server => 'my.jobtracker.com',
					:hadoop_node_job_tracker_http_port => '80',
					:hadoop_env_heapsize => '65535',
					:hadoop_env_jobtracker_opts => 'javaserver',
					:hadoop_env_namenode_opts => 'bigjava',
					:hadoop_env_secondarynamenode_opts => 'medjava',
	      }
	    end
	          			
			it do      
				should contain_file('/base/conf/core-site.xml'				  
        ).with_content(
				  /<name>fs.default.name<\/name>\n\t<value>hdfs:\/\/master:1111/
        ).with_content(
				  /<name>io.file.buffer.size<\/name>\n\t<value>20/
        ).with_content(
				    /<name>hadoop.tmp.dir<\/name>\n\t<value>\/tmp\/dir/
        ).with_content(
				  /<name>webinterface.private.actions<\/name>\n\t<value>noWayMan/
        ).with_content(
				  /<name>io.compression.codecs<\/name>\n\t<value>a,b,c/
        ).with_content(
				  /<name>io.compression.codec.lzo.class<\/name>\n\t<value>lzoClass/
				).with_content(
				  /<name>mapred.compress.map.output<\/name>\n\t<value>Okay/
				).with_content(
				  /<name>topology.script.file.name<\/name>\n\t<value>topologyfile<\/value>/
				).with_content(
				  /<name>hadoop.proxyuser.oozie.hosts<\/name>\n\t<value>\ooziehosts.com/
				).with_content(
				  /<name>hadoop.proxyuser.oozie.groups<\/name>\n\t<value>\ooziegroups/
				)
	      
	      should contain_file('/base/conf/hdfs-site.xml'	        
	      ).with_content(/<name>dfs.replication<\/name>\n\t<value>10/)			
	    	
	    	should contain_file('/base/conf/mapred-site.xml'
        ).with_content(
          /<name>mapred.job.tracker<\/name>\n\t<value>master:1337/
        ).with_content(
          /<name>mapreduce.jobtracker.http.address<\/name>\n\t<value>my\.jobtracker\.com:80/
        )
				
				should contain_file('/base/conf/hadoop-env.sh'
        ).with_content(
          /export JAVA_HOME=\/java\/home/
        ).with_content(
          /export HADOOP_HEAPSIZE=65535/
        ).with_content(
          /export HADOOP_JOBTRACKER_OPTS=javaserver/
        ).with_content(
          /export HADOOP_NAMENODE_OPTS=bigjava/
        ).with_content(
          /export HADOOP_SECONDARYNAMENODE_OPTS=medjava/
        )
			end
  	end
  	
  end   
  		

