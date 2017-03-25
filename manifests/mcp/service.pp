##
# MCP service
class archivematica::mcp::service inherits archivematica {
    # dashboard, mcp-x

    service {'archivematica-mcp-server':
        ensure    => running,
        enable    => true,
        subscribe => [
            Service['clamav-daemon'],
            Service['gearman-job-server'],
        ],
    }

    service {'archivematica-mcp-client':
        ensure    => running,
        enable    => true,
        subscribe => [
            Service['clamav-daemon'],
            Service['gearman-job-server'],
            Service['archivematica-mcp-server'],
        ],
    }

    service {'archivematica-dashboard':
        ensure    => running,
        enable    => true,
        subscribe => [
            Service['clamav-daemon'],
            Service['gearman-job-server'],
            Service['archivematica-mcp-server'],
            Service['archivematica-mcp-client'],
            Service['archivematica-storage-service']
        ]
    }
}
