{
  _class = "clan.service";
  manifest.name = "opentelemetry";
  roles.default = {
    interface = {lib, ...}: {
      options = {
        clickhouse = lib.mkOption {
          type = lib.types.str;
          description = "Clickhouse url";
        };
        monitorNginx = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Monitoring nginx endpoints with httpcheck";
        };
        monitorJournald = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Monitoring journald logs";
        };
      };
    };

    perInstance = {settings, ...}: {
      nixosModule = {
        config,
        lib,
        pkgs,
        ...
      }: {
        services.opentelemetry-collector = {
          enable = true;
          package = pkgs.opentelemetry-collector-contrib;
          settings = {
            receivers = {
              journald = lib.mkIf settings.monitorJournald {
                convert_message_bytes = true;
              };
              hostmetrics = {
                collection_interval = "30s";
                scrapers = {
                  cpu = { 
                    metrics = {
                      "system.cpu.utilization" = {
                        enabled = true;
                      };
                      "system.cpu.logical.count" = {
                        enabled = true;
                      };
                    };
                  };
                  load = { };
                  memory = {
                    metrics = {
                      "system.memory.utilization" = {
                        enabled = true;
                      };
                    };
                  };
                  filesystem = { 
                    metrics = {
                      "system.filesystem.utilization" = {
                        enabled = true;
                      };
                    };
                  };
                  disk = { };
                  network = { };
                  processes = { };
                };
              };
              httpcheck = lib.mkIf settings.monitorNginx {
                targets =
                  let
                    nginxVirtualHosts = config.services.nginx.virtualHosts;
                  in
                  lib.mapAttrsToList (
                    name: value:
                    # For each host, create a target object
                    {
                      endpoint = "https://${name}";
                      method = "GET";
                    }) nginxVirtualHosts;
              };
            };
            exporters = {
              clickhouse = {
                endpoint = settings.clickhouse;
                create_schema = true;
              };
            };
            processors = {
              resourcedetection = {
                detectors = [ "system" ];
              };
              batch = {
                send_batch_size = 10000;
                send_batch_max_size = 11000;
                timeout = "10s";
              };
              "transform/journald" = lib.mkIf settings.monitorJournald {
                log_statements = [
                  {
                    context = "log";
                    statements = [
                      # Copy all journald fields to attributes
                      ''merge_maps(attributes, body, "insert")''
                      # Set service name from SYSLOG_IDENTIFIER if available
                      ''set(resource.attributes["service.name"], attributes["SYSLOG_IDENTIFIER"])''
                      # Set the main log body to the message content
                      ''set(body, attributes["MESSAGE"])''
                    ];
                  }
                ];
              };
            };
            # extensions = {
            #   "file_storage/journald"= {
            #     directory = "/var/lib/otelcol/journald";
            #   };
            # };
            service = {
              # extensions = [ "file_storage/journald" ];
              pipelines = {
                metrics = {
                  receivers = [
                    "hostmetrics"
                  ] ++ lib.optionals settings.monitorNginx [ "httpcheck" ];
                  processors = [
                    "resourcedetection"
                    "batch"
                  ];
                  exporters = [
                    "clickhouse"
                  ];
                };
                logs = {
                  receivers = [] ++ lib.optionals settings.monitorJournald [ "journald" ];
                  processors = [
                    "resourcedetection"
                    "batch"
                  ] ++ lib.optionals settings.monitorJournald [ "transform/journald" ];
                  exporters = [
                    "clickhouse"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
