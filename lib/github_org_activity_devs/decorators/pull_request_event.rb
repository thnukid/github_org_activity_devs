module GithubOrgActivityDevs
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
end
