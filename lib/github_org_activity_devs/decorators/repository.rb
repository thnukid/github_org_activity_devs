module GithubOrgActivityDevs
  class RepositoryDecorator
    attr_reader :info

    def initialize(info)
      @info = info
    end

    def to_s
      [repo_link, description, language, spacer].join("\n")
    end

    def repo_link
      ['https://github.com/', info.full_name].join
    end

    def description
      info.description
    end

    def language
      info.language
    end

    private

    def spacer
      ['~']
    end
  end
end
