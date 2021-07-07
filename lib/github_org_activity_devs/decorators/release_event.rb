module GithubOrgActivityDevs
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
end
