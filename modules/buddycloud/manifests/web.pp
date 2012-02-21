class buddycloud::web {
    package { "apache2-mpm-event": ensure => installed }
    service { "apache2": ensure => running, require => Package["apache2-mpm-event"] }
    file { "/etc/apache2/sites-enabled/000-default":
        ensure  => absent,
        require => Package["apache2-mpm-event"],
        notify  => Service["apache2"],
    }
    file { "/etc/apache2/mods-enabled/rewrite.load":
        ensure => link,
        target => "/etc/apache2/mods-available/rewrite.load",
        require => Package["apache2-mpm-event"],
        notify  => Service["apache2"],
    }
    file { "/etc/apache2/mods-enabled/proxy.load":
        ensure => link,
        target => "/etc/apache2/mods-available/proxy.load",
        require => Package["apache2-mpm-event"],
        notify  => Service["apache2"],
    }
    file { "/etc/apache2/mods-enabled/ssl.load":
        ensure => link,
        target => "/etc/apache2/mods-available/ssl.load",
        require => Package["apache2-mpm-event"],
        notify  => Service["apache2"],
    }
}

define buddycloud::web::vhost() {

    $domain = $name

    include buddycloud::web

    file { "/etc/apache2/sites-enabled/buddycloud":
        ensure  => present,
        content => template("buddycloud/vhost.erb"),
        require => [
            Package["apache2-mpm-event"],
            File["/etc/apache2/mods-enabled/rewrite.load"],
            File["/etc/apache2/mods-enabled/proxy.load"],
            File["/etc/apache2/mods-enabled/ssl.load"],
            Exec["openssl-key-$domain"],
        ],
        notify  => Service["apache2"],
    }

}
