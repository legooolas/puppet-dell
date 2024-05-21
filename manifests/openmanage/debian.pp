#
# == Class: dell::openmanage::debian
#
# Install openmanage tools on Debian
#
class dell::openmanage::debian {
  assert_private ()

  if ($dell::manage_debian_apt) {
    include apt
  }

  $omsa_pkg_name = [
    'srvadmin-base',
    'srvadmin-storageservices',
    'srvadmin-omcommon',
  ]

  $ver = $facts['os']['distro']['codename'] ? {
    'xenial'  => 911,
    'bionic'  => 940,
    'focal'   => 10300,
    'jammy'   => 11010,
    default   => 11010,
  }

  apt::source{'dell':
    location => "http://linux.dell.com/repo/community/openmanage/${ver}/${facts['os']['distro']['codename']}",
    release  => $facts['os']['distro']['codename'],
    repos    => 'main',
    include  => {
      src => false,
    },
    key      => {
      id => '42550ABD1E80D7C1BC0BAD851285491434D8786F',
    },
  }

  package { $omsa_pkg_name:
    ensure  => present,
    require => Class['apt::update'],
  }

  Package[$omsa_pkg_name] -> Service <| tag == 'dell' |>
}
