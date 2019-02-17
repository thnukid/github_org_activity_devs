require 'github_org_activity_devs/version'
require 'rubygems'
require 'bundler'
Bundler.require(:default)

# ..
module GithubOrgActivityDevs
  # ...
  class Main
    def initialize
      Dotenv.load
      ActiveRecord::Base.establish_connection(db_configuration['development'])
    end

    private

    def db_configuration
      YAML.load(File.read(db_configuration_file))
    end

    def db_configuration_file
      File.join(File.expand_path(__dir__), '..', 'db', 'config.yml')
    end
  end
end
