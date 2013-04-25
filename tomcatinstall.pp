class base::tomcat6-centos6 {
	$tomcatjavapackage = [ "tomcat6" ]

	package { $tomcatjavapackage:
		ensure => installed }

	service { "tomcat6":
                enable  => "true",
                ensure => "running",
                hasrestart => "true",
                hasstatus => "true",
                require => Package["tomcat6"]
        }
}
