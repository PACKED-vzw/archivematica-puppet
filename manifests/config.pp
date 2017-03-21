##
# Configure ArchiveMatica
class archivematica::config inherits archivematica {

    include archivematica::storage_service::config
    include archivematica::mcp::config
}