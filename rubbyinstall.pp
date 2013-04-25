class training::ruby {

	file { "/etc/yum.repos.d/ruby187.repo":
		owner => "root",
		group => "root",
		mode => "0755",
		replace => true,
		source => "puppet:///training/ruby187.repo",
		}

	package { ruby:
		  ensure => "latest",
	}
	package { rubygems:
		  ensure => "latest",
	}
	package { "rails":
                  ensure => "2.2.2",
                  provider => gem,
        }

}
