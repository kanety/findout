describe Findout::Searcher do
  let :finder do
    UsersFinder.new
  end

  after :example do
    debug(finder)
  end

  context 'error' do
    it 'cannot use array as hash key' do
      params = { q: { id: { [ :gteq => 1 ] => 1 } } }
      expect { finder.search(params) }.to raise_error(Findout::ParseError)
    end

    it 'cannot use hash as hash key' do
      params = { q: { id: { { :gteq => 1 } => 1 } } }
      expect { finder.search(params) }.to raise_error(Findout::ParseError)
    end
  end
end
