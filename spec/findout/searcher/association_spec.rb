describe Findout::Searcher do
  let :finder do
    UsersFinder.new
  end

  after :example do
    debug(finder)
  end

  context 'association' do
    it 'recognizes association' do
      users = finder.search(q: { "group.id" => 1 })
      expect(users.size).to eq(1)
      expect(users.first.group.id).to eq(1)
    end

    it 'recognizes nested association' do
      users = finder.search(q: { "group.users.id" => 1 })
      expect(users.first.group.users.size).to eq(1)
      expect(users.first.group.users.first.id).to eq(1)
    end
  end
end
