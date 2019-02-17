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
        hash[developer.login] = client.user_events(developer.login)
      end
    end

    # { developer: [{ repos }] }
    def watch_events
      @watch_events = activity.each_with_object({}).each do |stream, hash|
        watch_events = stream.last.select { |x| x[:type] == 'WatchEvent' }
        developer = stream.first
        hash[developer] = watch_events
      end
    end

    def summary
      watch_events.each do |developer|
        name = developer.first
        repos = developer.last.map do |x|
          ['https://github.com/', x[:repo][:name]].join
        end
        output_console(name, repos)
      end
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
