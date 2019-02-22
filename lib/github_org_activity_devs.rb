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
      @client = Octokit::Client.new(access_token: github_token)
      @client.auto_paginate = true
    end

    def developers
      @developers ||= client.team_members(team_members_id)
    end

    def activity
      @activity ||= developers.each_with_object({}) do |developer, hash|
        developer_events = client.user_events(developer.login).group_by(&:type)
        hash[developer.login.to_sym] = developer_events
      end
    end

    def summary
    end

    private

    def output_console(name, repos)
      puts "#{name} (#{repos.count}) -> #{repos.join(', ')}"
    end

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
