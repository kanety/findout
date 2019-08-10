describe Findout::Searcher do
  let :finder do
    UsersFinder.new
  end

  after :example do
    debug(finder)
  end

  context 'shorthand query' do
    it 'resolves params' do
      users = finder.search(q: { 'id_eq' => 1 })
      expect(users.size).to eq(1)
      expect(users.first.id).to eq(1)
    end

    it 'resolves nested params' do
      users = finder.search(q: { 'or_id_eq' => 1, 'or_name_eq' => 'user_2' }).order(:id)
      expect(users.size).to eq(2)
      expect(users.first.id).to eq(1)
    end
  end

  context 'shorthand sort' do
    it 'resolves one param' do
      users = finder.search(s: 'id_desc')
      expect(users.first.id).to eq(50)
    end

    it 'resolves multiple params' do
      users = finder.search(s: ['id_desc', 'id_asc'])
      expect(users.first.id).to eq(50)
    end
  end
end
