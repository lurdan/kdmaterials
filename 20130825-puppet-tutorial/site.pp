class {
  'apache2':
    version => '2.2.22-13';
  'reprepro':;
  'gnupg':;
}

reprepro::mirror {
  '/var/www/debian':
    require => Class['apache2'],
    distributions => 'Codename: wheezy
Architectures: amd64
Description: wheezy-mirror
Components: main contrib
Update: wheezy wheezy-updates wheezy-security
',
    updates => 'Name: wheezy
Method: http://ftp.jp.debian.org/debian
Suite: wheezy
Components: main contrib
Architectures: amd64
VerifyRelease: AED4B06F473041FA
FilterFormula: Priority (==required)

Name: wheezy-updates
Method: http://ftp.jp.debian.org/debian
Suite: wheezy-updates
Components: main contrib
Architectures: amd64
VerifyRelease: AED4B06F473041FA
FilterFormula: Priority (==required)

Name: wheezy-security
Method: http://security.debian.org/debian-security
Suite: wheezy/updates
VerifyRelease: AED4B06F473041FA
FilterFormula: Priority (==required)
';
}

class apache2 ( $version = 'latest' ) {
  package { 'apache2':
    ensure => $version;
  }
  -> service { 'apache2':; }
}

class reprepro {
  package { 'reprepro':; }
}

class gnupg {
  package { 'gnupg':; }
}

define reprepro::mirror (
  $distributions,
  $upates,
  ) {
  file { "$name":
    ensure => directory;
  }
  -> file { "${name}/conf":
    ensure => directory;
  }
  -> file {
    "$name/conf/distributions":
      content => $distributions;
    "$name/conf/updates":
      content => $distributions;
  }
}

define apache2::site ( $content ) {

  file { "/etc/apache2/sites-enabled/${name}":
    content => $content,
    require => Package['apache2'],
    notify => Service['apache2'],
  }
}

