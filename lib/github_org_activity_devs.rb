# ..
module GithubOrgActivityDevs
  require 'rubygems'
  require 'bundler'
  Bundler.require(:default)

  require 'github_org_activity_devs/version'
  require 'github_org_activity_devs/octokit_client'
  require 'github_org_activity_devs/dot_env'
  require 'github_org_activity_devs/database_client'

  class RepositoryDecorator
    attr_reader :info

    def initialize(info)
      @info = info
    end

    def to_s
      [repo_link, description, language, spacer].join("\n")
    end

    def repo_link
      ['https://github.com/', info.full_name].join
    end

    def description
      info.description
    end

    def language
      info.language
    end

    private

    def spacer
      ['~']
    end
  end

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
      @developers ||= client.team_members(team_members_id)
                            .map(&:login)
                            .map(&:downcase).sort
    end

    # @return { 'login1' => { 'type_event': [{ 'event_json'}] }
    def activity
      @activity ||= developers.each_with_object({}) do |developer, hash|
        developer_events = client.user_events(developer)
                                 .sort_by { |x| x.type.downcase }
                                 .group_by(&:type)
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
            repos_names = activities.map(&:repo).map(&:name).uniq.sort
            repos = repos_names.map { |repo_name| repo_info(repo_name) }

            rows << ['', activity_name, ' ']
            rows << ['', '', repos.join("\n")]
          end
          rows << [' ','-', ' ']

          puts Terminal::Table.new rows: rows, width: 400, padding_left: 3, all_seperators: true
        end
      end
    end

    private

    def repo_info(repo_name)
      client_repository = if store.exist?(repo_name)
        store.fetch(repo_name)
      else
        store.write(repo_name, client.repository(repo_name))
        store.fetch(repo_name)
      end
      RepositoryDecorator.new(client_repository).to_s
    rescue Octokit::NotFound, Octokit::InvalidRepository => e
      e.message
    end

    def output_console(name, repos)
      puts "#{name} (#{repos.count}) -> #{repos.join(', ')}"
    end

    def team_members_id
      ENV.fetch('GITHUB_TEAM_MEMBERS_ID')
    end
  end
end
