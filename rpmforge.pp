class base::rpmforge {

	package { "rpmforge-release":	
		ensure => installed, 
		provider => rpm,
		source => "/tmp/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm",
		require => File["/tmp/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm"],
		}


	file {
		"/tmp/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm":
		source => "puppet:///base/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm",

		}


}	
