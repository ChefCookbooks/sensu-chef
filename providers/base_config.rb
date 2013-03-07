action :create do
  definitions = node.sensu.to_hash.reject do |key, value|
    !%w[rabbitmq redis api dashboard].include?(key.to_s) || value.nil?
  end

  # Remove the rabbitmq ssl key if we don't want ssl (otherwise sensu breaks)
  if !node.sensu.use_ssl
    Chef::Log.warn("Sensu: use_ssl is set to false so removing all ssl settings from the sensu::rabbitmq configuration.")
    definitions["rabbitmq"].delete("ssl")
  end

  sensu_json_file ::File.join(node.sensu.directory, "config.json") do
    mode 0644
    content definitions
  end
end
