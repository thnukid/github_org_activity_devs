# rubocop:disable Metrics/ModuleLength
module GithubOrgActivityDevs
  # rubocop:disable Metrics/BlockLength
  RSpec.describe Main do
    it 'has a version number' do
      expect(GithubOrgActivityDevs::VERSION).not_to be nil
    end

    context 'intialize' do
      subject { described_class.new }
      context 'database' do
        let(:development_config) { {} }
        let(:yaml_config_hash) do
          { 'development' => development_config }
        end

        before do
          allow(YAML).to receive(:load).and_return(yaml_config_hash)
        end

        it 'will establish a connection to the database' do
          expect(ActiveRecord::Base).to receive(:establish_connection)
            .with(development_config)
          subject
        end
      end

      context 'dotenv' do
        it 'loads dotenv' do
          expect(Dotenv).to receive(:load)
          subject
        end
      end

      context 'ocotokit' do
        before do
          allow(ENV).to receive(:fetch).with('GITHUB_OAUTH_TOKEN')
                                       .and_return('my-token')
          allow(Octokit::Client).to receive(:new)
            .and_call_original
        end

        it 'loads the client with oauth token' do
          expect(Octokit::Client).to receive(:new)
            .with(access_token: 'my-token')
          subject
        end
      end

      context '.developers' do
        before do
          allow_any_instance_of(Octokit::Client).to receive(:team_members)
            .and_return(team_members_stub)
        end

        let(:team_members_stub) do
          [double(login: 'developer'), double(login: 'developer2')]
        end

        it 'creates an array' do
          expect(subject.developers.class).to eq Array
        end

        it 'contains 2' do
          expect(subject.developers.count).to eq 2
        end
      end

      context '.activity' do
        subject { described_class.new.activity }

        before do
          allow_any_instance_of(Octokit::Client).to receive(:team_members)
            .and_return(team_members_stub)

          allow_any_instance_of(Octokit::Client).to receive(:user_events)
            .and_return(user_events_stub)
        end

        let(:team_members_stub) { [double(login: 'ariejan')] }

        let(:user_events_stub) do
          github_api_events.map do |event_name|
            OpenStruct.new({ :type => event_name.to_s, :repo => { :name => 'repo/name' } })
          end
        end

        let(:github_api_events) do
          ["IssueCommentEvent", "IssuesEvent", "PullRequestEvent", "PullRequestReviewCommentEvent", "PushEvent", "WatchEvent"]
        end

        context 'data_structure' do
          it 'contains the name' do
            expect(subject.keys).to contain_exactly(:ariejan)
          end

          it 'the name contains these hash kays' do
            expect(subject.fetch(:ariejan).keys.sort).to eq(github_api_events.sort)
          end

          it 'and each events contains an array' do
            github_api_events.each do |event_name|
              expect(subject.fetch(:ariejan).fetch(event_name).class).to eq Array
            end
          end

          context '.summary' do

          end
        end

      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable Metrics/ModuleLength
