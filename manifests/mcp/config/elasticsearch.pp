##
# Install elasticsearch using elastic-elasticsearch
class archivematica::mcp::config::elasticsearch () inherits archivematica {

    class {'elasticsearch':
        java_install      => true,
        manage_repo       => true,
        repo_version      => '1.7',
        restart_on_change => true,
        api_host          => $archivematica::mcp_elastic_server,
        api_port          => $archivematica::mcp_elastic_port,
    }

}