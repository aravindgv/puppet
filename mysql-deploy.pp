class galaxy::db::mysql {

		$packagelist = ["mysql-server"]

		package { $packagelist: 
				ensure => installed 
		}

		file {  "/mnt/logs" :
		          ensure => directory,
	        }

		file { "/mnt/logs/mysql":
                        owner => "mysql",
	                group => "mysql",
	                mode => "0644",
	                replace => false,
	                recurse => "true",
	                ignore => [".svn"],
	                source => "puppet:///galaxy/mysql",
	        }

		file { "/etc/my.cnf":
			owner => "root",
			group => "root",
			mode => "0644",
			replace => true,
			require => Package["mysql-server"],
			notify => Service[mysqld],
			source => "puppet:///galaxy/my.cnf",
		}


		define mysql_master_conf($shard_master_id) {

			file { "/etc/my.cnf":
				path => "/etc/my.cnf",
				owner => "root",
				group => "root",
				mode => "0644",
				content => template("galaxy/my_master.erb"),
				content => Service[mysqld],

			}

		}	

		service { mysqld:
			enable => "true",
			ensure => "running",
		#	require => File["/etc/my.cnf"]
		}

		$mysql_password = "aravind-secret"
 		exec { "set-mysql-password":
     			unless => "mysqladmin -uroot -p$mysql_password status",
         		path => ["/bin", "/usr/bin"],
	     		command => "mysqladmin -uroot password $mysql_password",
	         	require => Service["mysqld"],
		   }


		$user = "dchoc"
		$muser = "munin"
		$dbname  = "star"
		$password = "imaz0mb1e"
    		exec { "create-${dbname}-db":
                       unless => "/usr/bin/mysql -uroot -p${password} ${dbname}",
	               command => "/usr/bin/mysql -uroot -p$password  -e \"create database $dbname;\"",
	               require => Service["mysqld"],
	         }
	       exec { "grant-${dbname}-db":
	              unless => "/usr/bin/mysql -u${user} -p${password} ${dbname}",
	              command => "/usr/bin/mysql -uroot -p$password  -e \"grant all  on ${dbname}.* to ${user}@localhost identified by '$password'; grant all  on ${dbname}.* to ${user}@'%' identified by '$password';\"",
	              require => [Service["mysqld"], Exec["create-${dbname}-db"]]
              }
	       exec { "grant-${dbname}-munin":
	              unless => "/usr/bin/mysql -u${muser} -p${password} ${dbname}",
	              command => "/usr/bin/mysql -uroot -p$password  -e \"grant all  on ${dbname}.* to ${muser}@localhost identified by '$password'; grant all  on ${dbname}.* to ${muser}@'%' identified by '$password';\"",
	              require => [Service["mysqld"], Exec["create-${dbname}-db"]]
              }
	        
}

