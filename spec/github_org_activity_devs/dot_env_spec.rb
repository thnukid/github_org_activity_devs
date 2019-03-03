module GithubOrgActivityDevs
  RSpec.describe DotEnv do
    context 'when module is included' do
      let(:dummy_class) do
        class DummyClass
          include DotEnv
        end
      end

      subject { dummy_class.new }

      it 'loads dotenv' do
        expect(Dotenv).to receive(:load)
        subject
      end
    end
  end
end
