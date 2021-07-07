module GithubOrgActivityDevs
  class EventDecorator
    def self.decorate(activity_name, activity_data)
      klass = ['GithubOrgActivityDevs', '::', activity_name, 'Decorator'].join
      activity_data.map do |data|
        decorator = klass.constantize.new(data)
        decorator.to_s
      end
    rescue NameError
      GenericEventDecorator.new(activity_data).to_s
    end
  end
end
