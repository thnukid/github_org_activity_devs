module GithubOrgActivityDevs
  RSpec.describe Main do
    it 'has a version number' do
      expect(GithubOrgActivityDevs::VERSION).not_to be nil
    end

    context 'intialize' do
      subject { described_class.new }
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
  end
end
