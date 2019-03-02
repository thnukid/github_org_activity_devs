require 'rubygems'
require 'bundler'
Bundler.require(:default)

# ..
module GithubOrgActivityDevs
  require 'github_org_activity_devs/version'
  require 'github_org_activity_devs/octokit_client'
  require 'github_org_activity_devs/dot_env'
  require 'github_org_activity_devs/database_client'

  # ...
  class Main
    include DotEnv
    include DatabaseClient
    include OctokitClient

    def initialize
      puts self
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

    def output_console(name, repos)
      puts "#{name} (#{repos.count}) -> #{repos.join(', ')}"
    end

    def team_members_id
      ENV.fetch('GITHUB_TEAM_MEMBERS_ID')
    end
  end
end
