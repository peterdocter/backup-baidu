# Backup::Baidu

This Gem is aimed to provide a plugin for Backup, using Baidu's PCS (百度云盘) as storage.

## Installation

Add this line to your application's Gemfile:

    gem 'backup-baidu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install backup-baidu

## Usage

```ruby

require "backup-baidu"

Backup::Model.new(:foo, 'Description for foo') do

  store_with "Baidu" do |config|
    config.access_key_id = 'my_access_id'
    config.access_key_secret = 'my_access_key'
    config.path = '/apps/<my_path_value>'  # IMPORTANT - set this to your API's path value when signing up for baidu PCS
    config.keep = 10
  end
end

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
