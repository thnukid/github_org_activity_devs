module GithubOrgActivityDevs
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
end
