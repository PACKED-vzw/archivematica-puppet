class archivematica::storage_service::install inherits archivematica {

  package { 'archivematica-storage-service':
    ensure => installed,
  }

  Apt::Key['archivematica']->Apt::Source['archivematica']->Exec['apt_update']->Package['archivematica-storage-service']

}
