module GithubOrgActivityDevs
  module DatabaseClient
    extend self

    def self.included(_base)
      ActiveRecord::Base.establish_connection(db_configuration['development'])
      puts "#{self} activated"
    end

    def db_configuration
      YAML.load(File.read(db_configuration_file))
    end

    def db_configuration_file
      File.join(File.expand_path(__dir__), '..', '..', 'db', 'config.yml')
    end
  end
end
