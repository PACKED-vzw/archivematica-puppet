##
# Archivematica service collection
class archivematica::service () inherits archivematica {

    include archivematica::storage_service::service
    include archivematica::mcp::service

}