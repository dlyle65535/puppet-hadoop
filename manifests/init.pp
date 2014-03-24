# /etc/puppet/modules/hadoop/manifests/init.pp
class hadoop::init {

	require hadoop::params
	require hadoop::cluster

	include hadoop::cluster::master
	include hadoop::cluster::slave

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
	
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/hdfs-site.xml":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "hdfs-site-xml",
		content => template("hadoop/conf/hdfs-site.xml.erb"),
	}
	
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/hadoop-env.sh":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "hadoop-env-sh",
		content => template("hadoop/conf/hadoop-env.sh.erb"),
	}
	
	exec { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/bin/hadoop namenode -format":
		user => "hduser",
		alias => "format-hdfs",
		refreshonly => true,
		path => "/bin:/usr/bin:/usr/local/bin",
		subscribe => File["hdfs-dir"],
		require => [ File["hadoop-symlink"], File["java-app-dir"], File["hduser-bash_profile"], File["mapred-site-xml"], File["hdfs-site-xml"], File["core-site-xml"], File["hadoop-env-sh"]]
	}
	
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/mapred-site.xml":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "mapred-site-xml",
		content => template("hadoop/conf/mapred-site.xml.erb"),		
	}
	
	file { "/home/hduser/.ssh/":
		owner => "hduser",
		group => "hadoop",
		mode => "700",
		ensure => "directory",
		alias => "hduser-ssh-dir",
	}
	
	file { "/home/hduser/.ssh/id_rsa.pub":
		ensure => present,
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
		require => File["hduser-ssh-dir"],
	}
	
	file { "/home/hduser/.ssh/id_rsa":
		ensure => present,
		owner => "hduser",
		group => "hadoop",
		mode => "600",
		source => "puppet:///modules/hadoop/ssh/id_rsa",
		require => File["hduser-ssh-dir"],
	}
	
	file { "/home/hduser/.ssh/authorized_keys":
		ensure => present,
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
		require => File["hduser-ssh-dir"],
	}	
}
