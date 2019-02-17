module GithubOrgActivityDevs
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
          allow(ENV).to receive(:fetch).with('GITHUB_OAUTH_TOKEN').and_return('my-token')
          allow(ENV).to receive(:fetch).with('GITHUB_TEAM_MEMBERS_ID').and_return(team_members_id)
          allow(Octokit::Client).to receive(:team_members).and_return([{}])
        end

        it 'loads the client with oauth token' do
          expect(Octokit::Client).to receive(:new).with(access_token: 'my-token')
          subject
        end

        let(:team_members_id) { '000000' }
        it 'loads team_members' do
          expect(Octokit::Client).to receive(:team_members).with(team_members_id)
          subject.developers
        end
      end
    end
  end
end
