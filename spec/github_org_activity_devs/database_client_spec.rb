module GithubOrgActivityDevs
  RSpec.describe DatabaseClient do
    context 'when module is included' do
      let(:development_config) { {} }
      let(:yaml_config_hash) do
        { 'development' => development_config }
      end

      before do
        allow(YAML).to receive(:load).and_return(yaml_config_hash)
      end

      let(:dummy_class) do
        class DummyClass
          include DatabaseClient
        end
      end

      subject { dummy_class.new }

      it 'will establish a connection to the database' do
        expect(ActiveRecord::Base).to receive(:establish_connection)
          .with(development_config)
        subject
      end
    end
  end
end
