module GithubOrgActivityDevs
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
end
