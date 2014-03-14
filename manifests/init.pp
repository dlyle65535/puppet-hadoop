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
	file { "/home/hduser/.bash_profile":
		ensure => present,
		owner => "hduser",
		group => "hadoop",
		alias => "hduser-bash_profile",
		content => template("hadoop/home/bash_profile.erb"),
		require => User["hduser"]
	}
		
	file { "/home/hduser":
		ensure => "directory",
		owner => "hduser",
		group => "hadoop",
		alias => "hduser-home",
		require => [ User["hduser"], Group["hadoop"] ]
	}

	file {"$hadoop::params::hdfs_path":
		ensure => "directory",
		owner => "hduser",
		group => "hadoop",
		alias => "hdfs-dir",
		require => File["hduser-home"]
	}
	
	file {"$hadoop::params::hadoop_base":
		ensure => "directory",
		owner => "hduser",
		group => "hadoop",
		alias => "hadoop-base",
	}
	
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}.tar.gz":
		mode => 0644,
		owner => hduser,
		group => hadoop,
		source => "puppet:///modules/hadoop/hadoop-${hadoop::params::version}.tar.gz",
		alias => "hadoop-source-tgz",
		before => Exec["untar-hadoop"],
		require => File["hadoop-base"]
	}
	
	
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}":
		ensure => "directory",
		mode => 0644,
		owner => "hduser",
		group => "hadoop",
		alias => "hadoop-app-dir"
	}
		
	file { "${hadoop::params::hadoop_base}/hadoop":
		force => true,
		ensure => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}",
		alias => "hadoop-symlink",
		owner => "hduser",
		group => "hadoop",
		require => File["hadoop-source-tgz"],
		before => [ File["core-site-xml"], File["hdfs-site-xml"], File["mapred-site-xml"], File["hadoop-env-sh"]]
	}
	
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/core-site.xml":
		owner => "hduser",
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
