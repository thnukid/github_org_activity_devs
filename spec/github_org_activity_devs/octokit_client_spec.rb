module GithubOrgActivityDevs
  RSpec.describe OctokitClient do
    context 'when module is included' do
      let(:dummy_class) do
        class DummyClass
          include OctokitClient
        end
      end

      subject { dummy_class.new }

      context 'ocotokit' do
        before do
          allow(ENV).to receive(:fetch).with('GITHUB_OAUTH_TOKEN')
                                       .and_return('my-token')
        end

        it 'sets the middleware' do
          expect(Octokit).to receive(:middleware=)
          subject
        end

        it 'configures octokit' do
          octokit_mock = double.as_null_object
          allow(Octokit).to receive(:configure).and_yield(octokit_mock)

          expect(octokit_mock).to receive(:access_token=).with('my-token')
          expect(octokit_mock).to receive(:auto_paginate=).with(true)
          subject
        end
      end
    end
  end
end
