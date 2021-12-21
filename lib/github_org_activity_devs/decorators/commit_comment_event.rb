module GithubOrgActivityDevs
  class CommitCommentEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      [actor, action, comment, repo, created_at].join(' - ')
    end

    def comment
      data[:payload][:comment][:html_url]
    end

    def actor
      data[:actor][:display_login]
    end

    def action
      'commented'
    end

    def repo
      ['https://github.com/', data[:repo][:name]].join
    end

    def created_at
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end
  end
end
