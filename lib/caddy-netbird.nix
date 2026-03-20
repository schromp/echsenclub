url: ''
  @netbird {
    remote_ip 100.111.0.0/16
  }

  # Only proxy if the IP matches
  handle @netbird {
    reverse_proxy ${url}
  }

  # Fallback handle for everyone else
  handle {
    respond "Forbidden" 403
  }
''
