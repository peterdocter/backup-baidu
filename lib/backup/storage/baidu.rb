module Backup
  module Storage
    class Baidu < Base
      attr_accessor :api_key, :api_secret, :path

      def initialize(model, storage_id = nil, &block)
        super(model, storage_id)

        @path ||= 'backups'

        instance_eval(&block) if block_given?
      end

      private

      def connection
        return @connection if @connection
        @api_key = self.api_key
        @api_secret = self.api_secret
        @connection = ::Baidu::Client.new { }
        @connection.api_key = self.api_key
        @connection.api_secret = self.api_secret

        if session
          @connection.access_token = session
        else
          puts "First use Baidu you need authorize first!\n\n"
          puts @connection.authorize_url
          print "Type 'code' in callback url:"
          auth_code = $stdin.gets.chomp.split("\n").first
          @connection.token!(auth_code)
          save_session(@connection.access_token)
        end
        @connection
      end

      def save_session(token)
        @access_token = token
        FileUtils.mkdir_p(Config.cache_path) unless File.directory?(Config.cache_path)
        File.open(cached_file,"w") do |f|
          f.puts @access_token.to_hash.to_json
        end
      end

      def session
        return @session if @session
        if File.exist?(cached_file)
          stored_data = File.open(cached_file).read
          @session = OAuth2::AccessToken.from_hash(@connection.oauth_client, JSON.parse(stored_data))
          if @session.expired?
            Logger.info "Access Token has expired, not refresh a new token..."
            @session.refresh!
            Logger.info "Refresh successed. #{@session.token}"
            save_session(@session)
          end
        end
        @session
      end

      def cached_file
        File.join(Config.cache_path, "baidu-" + self.api_key + "-" + self.api_secret)
      end

      def transfer!
        remote_path = remote_path_for(package)
        package.filenames.each do |filename|
          src = File.join(Config.tmp_path, filename)
          dest = File.join(remote_path, filename)
          Logger.info "Storing '#{ dest }'..."
          connection.upload_single_file(dest, src)
        end
      end

      def remove!(package)
        remote_path = remote_path_for(package)
        Logger.info "Removeing '#{remote_path}' from Baidu..."
        connection.delete(remote_path)
      end
    end
  end
end
