require "pathname"

module Hobo

  def self.source_root
    @root ||= Pathname.new(File.expand_path("."))
  end
  
end
plugin_load_proc = lambda do |directory|
  # We only care about directories
  next false if !directory.directory?

  # If there is a plugin file in the top-level directory, then load
  # that up.
  plugin_file = directory.join("plugin.rb")
  if plugin_file.file?
    load(plugin_file)
    next true
  end
end

Hobo.source_root.join("plugins").children(true).each do |directory|
  # Ignore non-directories
  next if !directory.directory?

  # Load from this directory, and exit if we successfully loaded a plugin
  next if plugin_load_proc.call(directory)

  # Otherwise, attempt to load from sub-directories
  directory.children(true).each(&plugin_load_proc)
end
