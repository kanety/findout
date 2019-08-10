describe Findout::Config do
  context 'config' do
    let :config  do
      Findout::Config
    end

    it 'set value' do
      config.association_separator = '.'
      expect(config.association_separator).to eq('.')
    end

    it 'set by configure' do
      config.configure do |c|
        c.association_separator = '.'
      end
      expect(config.association_separator).to eq('.')
    end
  end
end
