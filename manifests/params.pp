# /etc/puppet/modules/hadoop/manifests/params.pp

class hadoop::params {

	include java::params
  
	$version = $::hadoop_node_version ? {
		undef			=> "0.20.203.0",
		default => $::hadoop_node_version,
	}
        
	$master = $::hadoop_node_master ? {
		undef			=> "hadoop01",
		default => $::hadoop_node_master,
	}
        
	$hdfsport = $::hadoop_node_hdfsport ? {
		undef			=> "8020",
		default => $::hadoop_node_hdfsport,
	}

	$replication = $::hadoop_node_replication ? {
		undef			=> "3",
		default => $::hadoop_node_replication,
	}

	$jobtrackerport = $::hadoop_node_jobtrackerport ? {
		undef			=> "8021",
    default => $::hadoop_node_jobtrackerport,
	}
	

	$java_home = $::hadoop_node_java_home ? {
		undef			=> "${java::params::java_base}/jdk${java::params::java_version}",
		default => $::hadoop_node_java_home,
	}
	
	$hadoop_base = $::hadoop_node_hadoop_base ? {
		undef			=> "/etc/hadoop-0.20",
    default => $::hadoop_node_hadoop_base,
	}

	$hdfs_path = $::hadoop_node_hdfs_path ? {
		undef => '/data/tmp/hadoop-${user.name}',
    default => $::hadoop_node_hdfs_path,		
	}
	
 $job_tracker_http_server = $::hadoop_node_job_tracker_http_server ? {
    undef => 'hadoop01',
    default => $::hadoop_node_job_tracker_http_server,
  }

  $job_tracker_http_port = $::hadoop_node_job_tracker_http_port ? {
    undef => '8022',
    default => $::hadoop_node_job_tracker_http_port,  
  }
    
}

