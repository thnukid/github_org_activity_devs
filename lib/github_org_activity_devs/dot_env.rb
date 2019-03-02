module GithubOrgActivityDevs
  module DotEnv
    extend self

    def self.included(_base)
      Dotenv.load
      puts "#{self} activated"
    end
  end
end
