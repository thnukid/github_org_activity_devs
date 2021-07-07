module GithubOrgActivityDevs
  class GenericEventDecorator
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      ['Not yet implemented event, ignored ', data.count].join
    end
  end
end
