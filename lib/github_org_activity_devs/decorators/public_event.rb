module GithubOrgActivityDevs
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
end
