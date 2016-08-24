class archivematica::storage_service::config inherits archivematica {

  include archivematica::storage_service::config::nginx
  include archivematica::storage_service::config::uwsgi

}
