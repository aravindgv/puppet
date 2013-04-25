class millionaire::db::mdbbackup {


	file { "/usr/bin/millionaire-db-backup" :
                owner => root,
                group => root,
                mode  => 0755,
                source => "puppet:///millionaire/millionaire-db-backup",
        }


	file { "/usr/bin/restoremillionairedb.sh" :
                owner => root,
                group => root,
                mode  => 0755,
                source => "puppet:///millionaire/restoremillionairedb.sh",
        }

     
      file { "/root/.s3cfg":
               owner => "root",
               group => "root",
               mode => "0644",
               source => "puppet:///millionaire/.s3cfg",
           }
     


	file { "/etc/yum.repos.d/s3tools.repo":
		owner => "root",
                group => "root",
                mode => "0644",
                source => "puppet:///base/s3tools.repo",
	}


	package { 's3cmd.noarch' :
	ensure => installed,
	}
        
}
