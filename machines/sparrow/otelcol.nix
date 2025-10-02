{ pkgs, ... }:
{
  services.opentelemetry-collector = {
    enable = true;
    package = pkgs.opentelemetry-collector-contrib;
    settings = {
      receivers = {
        journald = {
          # storage = "file_storage/journald";
        };
        hostmetrics = {
          collection_interval = "30s";
          scrapers = {
            cpu = { };
            load = { };
            memory = { };
            filesystem = { };
            disk = { };
            network = { };
            processes = { };
          };
        };
        # prometheus = {
        #   config = {
        #     scrape_configs = [
        #       {
        #         job_name = "";
        #       }
        #     ];
        #   };
        # };
      };
      exporters = {
        otlp = {
          endpoint = "http://localhost:4317";
          tls = {
            insecure = true;
          };
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
                ''set(resource.attributes["service.name"], body["SYSLOG_IDENTIFIER"])''
                ''set(attributes["message"], body["MESSAGE"])''
                # "delete(body)"
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
            receivers = [ "hostmetrics" ];
            processors = [
              "resourcedetection"
              "batch"
            ];
            exporters = [ "otlp" ];
          };
          logs = {
            receivers = [ "journald" ];
            processors = [
              "transform/journald"
              "batch"
            ];
            exporters = [ "otlp" ];
          };
        };
      };
    };
  };
}
