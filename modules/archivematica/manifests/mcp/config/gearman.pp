class archivematica::mcp::config::gearman inherits archivematica {

  if $configure_gearman == true {
    class { 'gearman':
        listen => $mcp_gearman_server,
        port => $mcp_gearman_port,
    }
  }
  
}
