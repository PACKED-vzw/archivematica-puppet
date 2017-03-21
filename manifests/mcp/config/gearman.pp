##
# Configure Gearman
class archivematica::mcp::config::gearman inherits archivematica {

  class {'gearman':
    listen => $archivematica::mcp_gearman_server,
    port   => $archivematica::mcp_gearman_port
  }

}
