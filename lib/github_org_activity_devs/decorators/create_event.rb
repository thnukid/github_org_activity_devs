module GithubOrgActivityDevs
  class CreateEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      #  bartvollebregt wants to merge `feature/fatboy_domain_refactor` (kabisa/terraform-aws-logdna) develop < master 3days ago
      [actor, action, ref, branch, repo, created_on].compact.join(' - ')
    end

    def ref
      data[:payload][:ref_type]
    end

    def created_on
      TimeDifference.between(Time.now, data[:created_at]).humanize
    end

    def branch
      data[:payload][:ref]
    end

    def repo
      ['https://github.com/', data[:repo][:name]].join
    end

    def action
      'created'
    end

    def actor
      data[:actor][:display_login]
    end
  end
end
