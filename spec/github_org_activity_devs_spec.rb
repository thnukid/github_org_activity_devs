# rubocop:disable Metrics/ModuleLength
module GithubOrgActivityDevs
  # rubocop:disable Metrics/BlockLength
  RSpec.describe Main do
    before do
      allow_any_instance_of(Octokit::Client).to receive(:team_members)
        .and_return(team_members_stub)

      allow_any_instance_of(Octokit::Client).to receive(:user_events)
        .and_return(user_events_stub)
      # .and_call_original
    end

    let(:team_members_stub) { [double(login: 'ariejan')] }

    let(:user_events_stub) do
      github_api_events.map do |event_name|
        OpenStruct.new({ :type => event_name.to_s, :repo => OpenStruct.new({:name => 'repo/name' }) })
      end
    end

    let(:github_api_events) do
      ["IssueCommentEvent", "IssuesEvent", "PullRequestEvent", "PullRequestReviewCommentEvent", "PushEvent", "WatchEvent"]
    end

    it 'has a version number' do
      expect(GithubOrgActivityDevs::VERSION).not_to be nil
    end

    context 'intialize' do
      subject { described_class.new }
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
      end

      context '.summary' do
        subject { described_class.new.summary }
        it 'creates a table' do
          expect(Terminal::Table).to receive(:new)
          subject
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable Metrics/ModuleLength
