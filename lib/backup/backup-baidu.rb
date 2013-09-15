require "backup"
require "json"
require "api4baidu"
require "oauth2"

Backup::Storage.send(:autoload, :Baidu, File.join(File.dirname(__FILE__),"backup/storage/baidu"))