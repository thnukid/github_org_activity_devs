module GithubOrgActivityDevs
  module OctokitClient
    extend self

    def self.included(_base)
      octokit_intitialize
      puts "#{self} activated"
    end

    def octokit_intitialize
      Octokit.middleware = stack
      Octokit.configure do |c|
        c.access_token = github_token
        c.auto_paginate = true
      end
      store.cleanup
    end

    def client
      Octokit.client
    end

    def stack
      FaradayManualCache.configure do |config|
        config.memory_store = store
      end

      Faraday::RackBuilder.new do |builder|
        builder.use Faraday::Request::Retry, exceptions: [Octokit::ServerError]
        builder.use Octokit::Middleware::FollowRedirects
        builder.use Octokit::Response::RaiseError
        builder.use Octokit::Response::FeedParser
        # builder.response :logger
        # builder.adapter Faraday.default_adapter

        # cache
        builder.use :manual_cache,
                    expires_in: 3600,
                    logger: logger
        builder.adapter Faraday.default_adapter
      end
    end

    def logger
      Logger.new(STDOUT)
    end

    def github_token
      ENV.fetch('GITHUB_OAUTH_TOKEN')
    end

    def cache_path
      File.join(File.expand_path(__dir__), '..', '..', 'cache')
    end

    def store
      ActiveSupport::Cache::FileStore.new(cache_path)
    end
  end
end
