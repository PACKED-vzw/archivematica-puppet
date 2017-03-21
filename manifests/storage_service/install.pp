##
# Install the storage service
class archivematica::storage_service::install inherits archivematica {

  package { 'archivematica-storage-service':
    ensure  => installed,
    require => Exec['apt_update']
  }

  if ! defined(Class['python']) {
    class {'python': }
  }

  python::pip {'setuptools':
    pkgname => 'setuptools',
    ensure  => latest,
  }

}
