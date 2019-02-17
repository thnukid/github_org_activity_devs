require 'github_org_activity_devs/version'
require 'rubygems'
require 'bundler'
Bundler.require(:default)

# ..
module GithubOrgActivityDevs
  # ...
  class Main
    attr_reader :client

    def initialize
      Dotenv.load
      ActiveRecord::Base.establish_connection(db_configuration['development'])
      Octokit.configure do |c|
        c.auto_paginate = true
      end
      @client = Octokit::Client.new(access_token: github_token)
    end

    def developers
      client.team_members(team_members_id)
    end

    private

    def github_token
      ENV.fetch('GITHUB_OAUTH_TOKEN')
    end

    def team_members_id
      ENV.fetch('GITHUB_TEAM_MEMBERS_ID')
    end

    def db_configuration
      YAML.load(File.read(db_configuration_file))
    end

    def db_configuration_file
      File.join(File.expand_path(__dir__), '..', 'db', 'config.yml')
    end
  end
end
