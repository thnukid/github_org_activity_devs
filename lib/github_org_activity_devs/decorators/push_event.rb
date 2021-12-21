module GithubOrgActivityDevs
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
end
