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
            .and_return([double(login: 'developer')])
        end

        it 'loads team_members developers' do
          expect(subject.developers.class).to eq Array
          expect(subject.developers.count).to eq 1
        end
      end

      context '.activity' do
        before do
          allow(subject).to receive(:developers).and_return(stub_developer)
        end

        let(:stub_developer) { [double(login: 'developer1')] }

        it 'calls user_events' do
          expect_any_instance_of(Octokit::Client).to receive(:user_events)
            .with('developer1')
          subject.activity
        end

        context 'returns user_events' do
          before do
            allow_any_instance_of(Octokit::Client).to receive(:user_events)
              .and_return(events)
          end

          let(:events) do
            [{}]
          end

          it 'includes the activity of a group member' do
            expect(subject.activity.include?('developer1')).to eq true
          end

          it 'includes the activity_events' do
            expect(subject.activity.fetch('developer1').last).to eq({})
          end
        end
      end

      context '.watch_events' do
        before do
          allow(subject).to receive(:activity).and_return(stub_user_events)
        end

        let(:stub_user_events) do
          [
            ['developer1', [{ type: 'WatchEvent' }]],
            ['empty', [{ type: 'PushEvent' }]]
          ]
        end

        it 'finds the developers' do
          expect(subject.watch_events.fetch('developer1').class).to eq Array
          expect(subject.watch_events.fetch('empty').class).to eq Array
        end

        it 'finds the WatchEvent' do
          expect(subject.watch_events.fetch('developer1').count).to eq 1
          expect(subject.watch_events.fetch('empty').count).to eq 0
        end
      end

      context '.summary' do
        before do
          allow(subject).to receive(:watch_events).and_return(stub_watch_events)
        end
        let(:stub_watch_events) do
          [
            ['developer1', [{ repo: { name: 'test/test-repo' } }]]
          ]
        end

        it 'prints to console' do
          expect(subject).to receive(:output_console)
            .with('developer1', ['https://github.com/test/test-repo'])
          subject.summary
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable Metrics/ModuleLength
