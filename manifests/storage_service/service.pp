##
# storage_service service
class archivematica::storage_service::service inherits archivematica {
    # storage-service
    service {'archivematica-storage-service':
        ensure    => 'running',
        enable    => true,
        subscribe => [
            Service['clamav-daemon'],
            Service['gearman-job-server'],
            Service['archivematica-mcp-server'],
            Service['archivematica-mcp-client']
        ]
    }
}
