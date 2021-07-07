module GithubOrgActivityDevs
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
end
