# /etc/puppet/modules/hadoop/manifests/init.pp
class hadoop::init {

	require hadoop::params
	
	#include hadoop::cluster::master
	#include hadoop::cluster::slave

  #contain repos
  
	group { "hadoop":
		ensure => present,
		gid => "123"
	}

	user { "hdfs":
		ensure => present,
		comment => "Hadoop",
		password => "!!",
		uid => "102",
		gid => "124",
		shell => "/bin/bash",
		home => "/home/hduser",
		require => Group["hadoop"],
	}
	

	package { "hadoop-0.20":
    ensure => present
  }
  
  package { "hadoop-0.20-native":
    ensure => present
  }
  
	file { "${hadoop::params::hadoop_base}/conf/core-site.xml":
		owner => "hdfs",
		group => "hadoop",
		mode => "644",
		alias => "core-site-xml",
		content => template("hadoop/conf/core-site.xml.erb"),
	}
	
	file { "${hadoop::params::hadoop_base}/conf/hdfs-site.xml":
		owner => "hdfs",
		group => "hadoop",
		mode => "644",
		alias => "hdfs-site-xml",
		content => template("hadoop/conf/hdfs-site.xml.erb"),
	}
	
	
	
	
	
#	file { "/home/hduser/.ssh/":
#		owner => "hduser",
#		group => "hadoop",
#		mode => "700",
#		ensure => "directory",
#		alias => "hduser-ssh-dir",
#	}
#	
#	file { "/home/hduser/.ssh/id_rsa.pub":
#		ensure => present,
#		owner => "hduser",
#		group => "hadoop",
#		mode => "644",
#		source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
#		require => File["hduser-ssh-dir"],
#	}
#	
#	file { "/home/hduser/.ssh/id_rsa":
#		ensure => present,
#		owner => "hduser",
#		group => "hadoop",
#		mode => "600",
#		source => "puppet:///modules/hadoop/ssh/id_rsa",
#		require => File["hduser-ssh-dir"],
#	}
#	
#	file { "/home/hduser/.ssh/authorized_keys":
#		ensure => present,
#		owner => "hduser",
#		group => "hadoop",
#		mode => "644",
#		source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
#		require => File["hduser-ssh-dir"],
#	}	
}
