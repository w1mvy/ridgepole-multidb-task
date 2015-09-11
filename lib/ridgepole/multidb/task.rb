require "ridgepole/multidb/task/version"
if defined? Rails
  module Ridgepole
    class Railtie < Rails::Railtie
      rake_tasks do
        load "ridgepole/multidb/task/schema.rake"
      end
    end
  end
end
