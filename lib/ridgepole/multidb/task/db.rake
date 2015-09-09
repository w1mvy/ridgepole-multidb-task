namespace :db do
  namespace :schema do
    #FIXME
    SCHEMA_FILE = "db/schema/schema.rb"

    desc "Show diff between schema file and table configuration"
    task :diff => :environment do
      configs.each do |connection_name, config|
        ridgepole_diff(SCHEMA_FILE, connection_name, config)
      end
    end

    desc "Apply schema files to databases"
    task :apply => :environment do
      execute_ridgepole(configs, "--apply")
    end

    desc "Dry run apply schema"
    task :apply_dry_run => :environment do
      execute_ridgepole(configs, "--apply", dry_run: true)
    end

    desc "Merge schema file and table configutation"
    task :merge => :environment do
      execute_ridgepole(configs, "--merge")
    end

    desc "Dry run merge"
    task :merge_dry_run => :environment do
      execute_ridgepole(configs, "--merge", dry_run: true)
    end

    def execute_ridgepole(configs, mode, dry_run: false)
      configs.each do |connection_name, config|
        ridgepole_apply(SCHEMA_FILE, connection_name, config, mode, dry_run: dry_run)
      end
    end

    def ridgepole_diff(schema_file, connection_name, config)
      puts format_label("CONNECTION [#{ connection_name } (#{ config['host'] })] BEGIN")
      output = `RAILS_ENV=#{ Rails.env } CONNECTION=#{ connection_name } bundle exec ridgepole --enable-mysql-awesome --diff '#{ config.to_json }' #{ schema_file }`
      puts highlight_sql(output)
      puts format_label("CONNECTION [#{ connection_name } (#{ config['host'] })] END")
    end

    def ridgepole_apply(schema_file, connection_name, config, mode, dry_run: false)
      puts format_label("CONNECTION [#{ connection_name } (#{ config['host'] })] BEGIN")
      command  = "RAILS_ENV=#{ Rails.env } CONNECTION=#{ connection_name } bundle exec ridgepole --enable-mysql-awesome #{ mode } -c '#{ config.to_json }' -f #{ schema_file }"
      command += " --dry-run" if dry_run
      output = `#{ command }`
      puts highlight_sql(output)
      puts format_label("CONNECTION [#{ connection_name } (#{ config['host'] })] END")
    end

    def highlight_sql(text)
      text
        .gsub(/CREATE\s+.+(?=\()/, "\\0".colorize(:light_green))
        .gsub(/ALTER\s+TABLE\s+.+\s+ADD.+/, "\\0".colorize(:light_green))
        .gsub(/ALTER\s+TABLE\s+.+\s+DROP.+/, "\\0".colorize(:light_red))
        .gsub(/ALTER\s+TABLE\s+.+\s+(CHANGE|MODIFY).+/, "\\0".colorize(:light_yellow))
        .gsub(/DROP\s+.+/, "\\0".colorize(:light_red))
    end

    def format_label(text)
      result = "=== #{ text } "
      result + "=" * [0, 70 - result.size].max
    end

    def configs
      return @configs if @configs
      @configs = ActiveRecord::Base.configurations.dup
      @configs.delete(Rails.env)
      @configs
    end
  end
end
