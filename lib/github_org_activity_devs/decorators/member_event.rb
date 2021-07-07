module GithubOrgActivityDevs
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
end
