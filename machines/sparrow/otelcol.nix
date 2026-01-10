{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.opentelemetry-collector = {
    enable = true;
    package = pkgs.opentelemetry-collector-contrib;
    settings = {
      receivers = {
        journald = {
          # storage = "file_storage/journald";
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
        httpcheck = {
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
          endpoint = "tcp://0.0.0.0:9900";
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
        "transform/journald" = {
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
              "httpcheck"
            ];
            processors = [
              "resourcedetection"
              "batch"
            ];
            exporters = [
              "clickhouse"
            ];
          };
          logs = {
            receivers = [ "journald" ];
            processors = [
              "transform/journald"
              "batch"
            ];
            exporters = [
              "clickhouse"
            ];
          };
        };
      };
    };
  };
}
