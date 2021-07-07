module GithubOrgActivityDevs
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
end
