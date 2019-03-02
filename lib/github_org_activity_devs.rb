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
      setup
    end

    # @return ['login1', 'login2'] if so
    def developers
      @developers ||= client.team_members(team_members_id).map(&:login).sort
    end

    # @return { 'login1' => { 'type_event': [{ 'event_json'}] }
    def activity
      @activity ||= developers.each_with_object({}) do |developer, hash|
        developer_events = client.user_events(developer).group_by(&:type)
        hash[developer.to_sym] = developer_events
      end
    end

    def summary
      @summary ||= activity.each do |developer_name, developer|
        if developer.keys.present?
          rows = []
          rows << [developer_name.to_s + "\n", '', '']
          rows << [' ',' ', ' ']

          developer.each do |activity_name, activities|
            repos = activities.map(&:repo).map(&:name).uniq.sort

            rows << ['', activity_name, ' ']
            rows << ['', '', repos.join("\n")]
          end
          rows << [' ','-', ' ']

          puts Terminal::Table.new rows: rows, width: 400, padding_left: 3, all_seperators: true
        end
      end
    end

    private

    def setup
      Dotenv.load
      ActiveRecord::Base.establish_connection(db_configuration['development'])
      @client = Octokit::Client.new(access_token: github_token)
      @client.auto_paginate = true
    end

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
