class base::vmwaretools {
	$openvmtools = ["open-vm-source", "open-vm-tools"]
	$prereqs = ["gcc-c++","kernel-devel"]
	$mountpoint = "/mnt/puppet"
	$share = "/data/globalshare"
	$server = "everest.dchoc.net"

	package { $prereqs:
	        ensure => present,
	        }  
	package { $openvmtools:
	        ensure => purged,
	        }  
	# we need to mount the nfs share to get at the install script
        exec { "create mountpoint":
		     path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"], 
	            command => "mkdir -p ${mountpoint}",
		    unless  => "ls  ${mountpoint}",
        }  
       exec { "mount puppetshare":
               command  => "/bin/mount -t nfs ${server}:${share} $mountpoint",
	       timeout  => 300,
	       logoutput => true,
	       require  => Exec["create mountpoint"],
       }
       exec { "unmount puppetshare":
               command  => "/bin/umount $mountpoint",
	       timeout  => 300,
	       logoutput => true,
	       require  => Exec["install vmwaretools"],
       }  
       exec { "install vmwaretools":
               creates  => "/etc/vmware-tools",
	       environment => ["PAGER=/bin/cat","DISPLAY=:9"],
	       cwd      => "/mnt/puppet/vmware-tools-distrib",
	       command  => "/mnt/puppet/vmware-tools-distrib/vmware-install.pl --default",
	       logoutput => true,
	       timeout  => 300,
	       require  => Exec["mount puppetshare"],
     }  
     ### Start the service
     service { "vmware-tools":
             	ensure => running,
	        enable => true,
		hasstatus => false,
		pattern => "vmware-guestd --background",
		require => [Package[$prereqs], Exec["install vmwaretools"]],
     }   
 }

