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

   $file_buffer_size = $::hadoop_file_buffer_size ? {
    undef => '131072',
    default => $::hadoop_file_buffer_size,   
  }
  
  $tmp_dir = $::hadoop_tmp_dir ? {
    undef => '/data/tmp/hadoop-${user.name}',
    default => $::hadoop_tmp_dir,   
  }
  
  $enable_private_actions = $::hadoop_enable_private_actions ? {
    undef => 'false',
    default => $::hadoop_enable_private_actions,   
  }
        
  $compression_codecs = $::hadoop_compression_codecs ? {
    undef => 'com.hadoop.compression.lzo.LzopCodec',
    default => $::hadoop_compression_codecs,   
  }
   
  $lzo_class = $::hadoop_lzo_class ? {
    undef => 'com.hadoop.compression.lzo.LzoCodec',
    default => $::hadoop_lzo_class,   
  }
         	
  $compress_map_output = $::hadoop_compress_map_output ? {
    undef => 'true',
    default => $::hadoop_compress_map_output,   
  }
         	
  $topology_script_file_name = $::hadoop_topology_script_file_name ? {
    undef => '',
    default => $::hadoop_topology_script_file_name,   
  }

  $oozie_hosts = $::hadoop_oozie_hosts ? {
    undef => '*',
    default => $::hadoop_oozie_hosts,   
  }
  
  $oozie_groups = $::hadoop_oozie_groups ? {
    undef => '*',
    default => $::hadoop_oozie_groups,   
  }
   
 $job_tracker_http_server = $::hadoop_node_job_tracker_http_server ? {
    undef => 'hadoop01',
    default => $::hadoop_node_job_tracker_http_server,
  }

  $job_tracker_http_port = $::hadoop_node_job_tracker_http_port ? {
    undef => '8022',
    default => $::hadoop_node_job_tracker_http_port,  
  }
   
  $env_heapsize = $::hadoop_env_heapsize ? {
    undef => '1000',
    default => $::hadoop_env_heapsize,  
  } 
   
  $env_jobtracker_opts = $::hadoop_env_jobtracker_opts ? {
    undef => '-Xmx4g',
    default => $::hadoop_env_jobtracker_opts,  
  }  
  
    $env_namenode_opts = $::hadoop_env_namenode_opts ? {
    undef => '-Xmx4g',
    default => $::hadoop_env_namenode_opts,  
  }  
  
    $env_secondarynamenode_opts = $::hadoop_env_secondarynamenode_opts ? {
    undef => '-Xmx4g',
    default => $::hadoop_env_secondarynamenode_opts,  
  }  
  
}

