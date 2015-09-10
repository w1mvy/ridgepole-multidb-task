connection_name = ENV["CONNECTION"]
rails_root      = ENV["RAILS_ROOT"]
Dir[File.join(rails_root, "db/schema", connection_name, "*_schema.rb")].each do |schema_file|
  require schema_file
end
