action :create do
  definitions = Sensu::Helpers.select_attributes(
    node.sensu,
    %w[rabbitmq redis api dashboard]
  )

  # Remove the rabbitmq ssl key if we don't want ssl (otherwise sensu breaks)
  if !node.sensu.use_ssl
    Chef::Log.warn("Sensu: use_ssl is set to false so removing all ssl settings from the sensu::rabbitmq configuration.")
    definitions["rabbitmq"].delete("ssl")
  end

  sensu_json_file ::File.join(node.sensu.directory, "config.json") do
    content Sensu::Helpers.sanitize(definitions)
  end
end
