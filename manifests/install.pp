##
# Install Archivematica, MCP and the storage service
class archivematica::install () inherits archivematica {

    ##
    # Archivematica is installed from PPA's, so we first must add the keys
    apt::key {'archivematica':
      id     => '5236CA08',
      source => 'https://packages.archivematica.org/1.6.x/key.asc',
    }

    ##
    # Install repositories
    apt::ppa {'ppa:archivematica/externals':
      notify => Exec['apt_update'],
    }

    apt::source {'archivematica':
      location     => 'http://packages.archivematica.org/1.6.x/ubuntu',
      release      => 'trusty',
      repos        => 'main',
      architecture => 'amd64',
      notify       => Exec['apt_update'],
    }

    include archivematica::storage_service::install
    include archivematica::mcp::install
}