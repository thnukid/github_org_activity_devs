# ..
module GithubOrgActivityDevs
  require 'rubygems'
  require 'bundler'
  require 'pry'
  require 'time_difference'
  Bundler.require(:default)

  require 'github_org_activity_devs/version'
  require 'github_org_activity_devs/octokit_client'
  require 'github_org_activity_devs/dot_env'
  require 'github_org_activity_devs/database_client'

  require 'github_org_activity_devs/decorators/event'
  require 'github_org_activity_devs/decorators/commit_comment_event'
  require 'github_org_activity_devs/decorators/create_event'
  require 'github_org_activity_devs/decorators/delete_event'
  require 'github_org_activity_devs/decorators/event'
  require 'github_org_activity_devs/decorators/fork_event'
  require 'github_org_activity_devs/decorators/generic_event'
  require 'github_org_activity_devs/decorators/issue_comment_event'
  require 'github_org_activity_devs/decorators/issues_event'
  require 'github_org_activity_devs/decorators/member_event'
  require 'github_org_activity_devs/decorators/public_event'
  require 'github_org_activity_devs/decorators/pull_request_event'
  require 'github_org_activity_devs/decorators/release_event'
  require 'github_org_activity_devs/decorators/watch_event'
  require 'github_org_activity_devs/decorators/push_event'
  require 'github_org_activity_devs/decorators/pull_request_review_comment_event'
  require 'github_org_activity_devs/decorators/repository'

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
        developer_events = client.user_events(developer).select { |k|
          k.created_at > 2.week.ago
        }.sort_by { |x| x.type.downcase }
          .group_by(&:type)
        hash[developer.to_sym] = developer_events
      end
    end

    def summary
      @summary ||= activity.each do |name, events|
        puts ''
        puts ''
        puts name

        events.each do |name_of_event, event|
          event_sorted = event.sort_by(&:created_at).reverse
          text = EventDecorator.decorate(name_of_event, event_sorted)
          puts ''
          puts name_of_event
          puts text
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
