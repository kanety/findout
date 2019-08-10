describe Findout::Searcher do
  let :finder do
    UsersFinder.new
  end

  after :example do
    debug(finder)
  end

  context 'alter query' do
    it 'resolves at 1st depth' do
      users = finder.search(q: { keyword: 'user 10' }).order(:id)
      expect(users.size).to eq(1)
      expect(users.first.id).to eq(10)
    end

    it 'resolves at 2nd depth' do
      users = finder.search(q: { or_keyword_columns_word_all: 'user 10' }).order(:id)
      expect(users.size).to eq(1)
      expect(users.first.id).to eq(10)
    end
  end

  context 'alter sort' do
    it 'resolves without direction' do
      users = finder.search(s: :created_at_updated_at)
      expect(users.size).to eq(50)
      expect(users.first.id).to eq(1)
    end

    it 'resolves with direction' do
      users = finder.search(s: { created_at_updated_at: :desc })
      expect(users.size).to eq(50)
      expect(users.first.id).to eq(50)
    end
  end
end
