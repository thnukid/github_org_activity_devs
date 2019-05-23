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

  class EventDecorator
    def self.decorate(activity_name, activity_data)
      klass = ['GithubOrgActivityDevs', '::', activity_name, 'Decorator'].join
      activity_data.map do |data|
        decorator = klass.constantize.new(data)
        decorator.to_s
      end
    rescue NameError
      GenericEventDecorator.new(activity_data).to_s
    end
  end

  class ReleaseEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      [actor, action, name, release, repo, created_at].join(' - ')
    end

    def actor
      data[:actor][:display_login]
    end

    def action
      data[:payload][:action]
    end

    def name
      data[:payload][:release][:name]
    end

    def release
      data[:payload][:release][:html_url]
    end

    def repo
      ['https://github.com/', data[:repo][:name]].join
    end

    def created_at
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end
  end

  class DeleteEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      [actor, action,type, ref, repo, created_at].join(' - ')
    end

    def actor
      data[:actor][:display_login]
    end

    def action
      'deleted'
    end

    def type
      data[:payload][:ref_type]
    end

    def ref
      data[:payload][:ref]
    end

    def repo
      ['https://github.com/', data[:repo][:name]].join
    end

    def created_at
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end
  end

  class IssuesEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      [actor, action, issue, repo, created_at].join(' - ')
    end

    def actor
      data[:actor][:display_login]
    end

    def action
      data[:payload][:action]
    end

    def repo
      data[:payload][:issue][:html_url]
    end

    def created_at
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end

    def issue
      data[:payload][:issue][:title]
    end
  end

  class PublicEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      [actor, action, repo, created_at].join(' - ')
    end

    def actor
      data[:actor][:display_login]
    end

    def action
      'open sourced'
    end

    def repo
      ['https://github.com/', data[:repo][:name]].join
    end

    def created_at
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end

  end

  class CommitCommentEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      [actor, action, comment, repo, created_at].join(' - ')
    end

    def comment
      data[:payload][:comment][:html_url]
    end

    def actor
      data[:actor][:display_login]
    end

    def action
      'commented'
    end

    def repo
      ['https://github.com/', data[:repo][:name]].join
    end

    def created_at
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end
  end

  class MemberEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      [actor, action, who, repo, created_at].join(' - ')
    end

    def who
      data[:payload][:member][:html_url]
    end

    def actor
      data[:actor][:display_login]
    end

    def action
      data[:payload][:action]
    end

    def repo
      ['https://github.com/', data[:repo][:name]].join
    end

    def created_at
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end
  end

  class PullRequestReviewCommentEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      [actor, action, repo, created_at].join(' - ')
    end

    def actor
      data[:actor][:display_login]
    end

    def action
      data[:payload][:action]
    end

    def repo
      data[:payload][:pull_request][:html_url]
    end

    def created_at
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end
  end

  class ForkEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      [actor, action, repo, link, created_at].join(' - ')
    end

    def actor
      data[:actor][:display_login]
    end

    def action
      'forked'
    end

    def repo
      ['https://github.com/', data[:repo][:name]].join
    end

    def link
      data[:payload][:forkee][:html_url]
    end

    def created_at
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end
  end

  class WatchEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      [actor, action, repo, created_at].join(' - ')
    end

    def actor
      data[:actor][:display_login]
    end

    def action
      [data[:payload][:action], 'watching'].join(' ')
    end

    def repo
      ['https://github.com/', data[:repo][:name]].join
    end

    def created_at
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end
  end

  class  PushEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      [actor, action, ref, repo, created_at].join(' - ')
    end

    def ref
      data[:payload][:ref]
    end

    def actor
      data[:actor][:display_login]
    end

    def repo
      ['https://github.com/', data[:repo][:name]].join
    end

    def created_at
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end

    def action
      [data[:payload][:distinct_size], 'commits'].join(' ')
    end
  end

  class PullRequestEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      [actor, action, title, pull_request, created_at].join(' - ')
    end

    def pull_request
      data[:payload][:pull_request][:html_url]
    end

    def title
      data[:payload][:pull_request][:title]
    end

    def action
      data[:payload][:action]
    end

    def actor
      data[:actor][:display_login]
    end

    def created_at
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end
  end

  class IssueCommentEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      [actor, action, issue, link, created_on].join(' - ')
    end

    def actor
      data[:actor][:display_login]
    end

    def action
      'commented'
    end

    def issue
      data[:payload][:issue][:title]
    end

    def link
      data[:payload][:comment][:html_url]
    end

    def created_on
      TimeDifference.between(Time.now, data[:payload][:comment][:created_at]).humanize
    end
  end

  class CreateEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      #  bartvollebregt wants to merge `feature/fatboy_domain_refactor` (kabisa/terraform-aws-logdna) develop < master 3days ago
      [actor, action, ref, branch, repo, created_on].compact.join(' - ')
    end

    def ref
      data[:payload][:ref_type]
    end

    def created_on
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end

    def branch
      data[:payload][:ref]
    end

    def repo
      ['https://github.com/', data[:repo][:name]].join
    end

    def action
      'created'
    end

    def actor
      data[:actor][:display_login]
    end
  end

  class GenericEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      ['Not yet implemented event, ignored ', data.count].join
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
