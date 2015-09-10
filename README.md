# Ridgepole::Multidb::Task

Define task to apply ridgepole used multidb & multischemafiles for Rails

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ridgepole-multidb-task'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ridgepole-multidb-task

## Usage

```
[4] pry(main)> ActiveRecord::Base.configurations.keys
=> ["database_a", "database_b"]
```

If your ar configuration is multi db, define schema files followers.

```
.
└── db
    └── schema
        ├── database_a
        │   ├── user_table_schema.rb
        │   └── admin_schema.rb
        └── database_b
            ├── item_table_schema.rb
            └── cart_schema.rb
```

define task followers

```
rake db:schema:apply                    # Apply schema files to databases
rake db:schema:apply_dry_run            # Dry run apply schema
rake db:schema:diff                     # Show diff between schema file and table configuration
rake db:schema:merge                    # Merge schema file and table configutation
rake db:schema:merge_dry_run            # Dry run merge
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/ridgepole-multidb-task/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
