module GithubOrgActivityDevs
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
end
