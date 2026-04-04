{ config, pkgs, ... }:
{
  services.clickhouse = {
    enable = true;
    serverConfig = {
      tcp_port = 9900;
      http_port = 9901;

      listen_host = "::";

      mark_cache_size = 104857600;

      max_server_memory_usage_to_ram_ratio = 0.75;
      background_pool_size = 2;
      max_thread_pool_size = 2000;

      merge_tree = {
        number_of_free_entries_in_pool_to_lower_max_size_of_merge = 2;
        number_of_free_entries_in_pool_to_execute_mutation = 2;
        number_of_free_entries_in_pool_to_execute_optimize_entire_partition = 2;
      };
    };
    extraServerConfig = ''
      <clickhouse>
          <query_log remove="1" />
          <trace_log remove="1" />
          <metric_log remove="1" />
          <asynchronous_metric_log remove="1" />
          <part_log remove="1" />
          <background_schedule_pool_log remove="1" />
          <text_log remove="1" />
      </clickhouse>
    '';

    usersConfig = {
      profiles = {
        default = {
          max_threads = 2;
          max_download_threads = 2;
          max_block_size = 8192;
          input_format_parallel_parsing = 0;
          output_format_parallel_formatting = 0;
        };
      };
    };
  };

  # TODO: ...
  # environment.etc = {
  #   "clickhouse-server/users.d/300-nixmanaged-user-config.xml" = {
  #     source = config.clan.core.vars.generators."clickhouse-default-user".files."password".path;
  #   };
  # };

  clan.core.vars.generators."clickhouse-default-user" = {
    files."password" = {
      secret = true;
      owner = "clickhouse";
      group = "clickhouse";
    };
    runtimeInputs = with pkgs; [
      coreutils
      openssl
      gawk
    ];
    script = ''
      PASS=$(openssl rand -hex 8)
      HASH=$(echo -n "$PASS" | sha256sum | awk '{print $1}')

      cat <<EOF > $out/password
      <clickhouse>
          <users>
              <default>
                  <password_sha256_hex>$HASH</password_sha256_hex>
              </default>
          </users>
      </clickhouse>
      EOF
    '';
  };
}
