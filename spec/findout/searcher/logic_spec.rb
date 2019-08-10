describe Findout::Searcher do
  let :finder do
    UsersFinder.new(relation: User.order(:id))
  end

  after :example do
    debug(finder)
  end

  context 'default logic' do
    it 'combines with :and' do
      users = finder.search(q: [ { id: 1 }, { name: 'user_1' }])
      expect(users.size).to eq(1)
      expect(users.first.id).to eq(1)
    end
  end

  context 'basic logic' do
    it 'combines with :and' do
      users = finder.search(q: { and: { id: 1, name: 'user_2' } })
      expect(users.size).to eq(0)
    end

    it 'combines with :or' do
      users = finder.search(q: { or: { id: 1, name: 'user_2' } })
      expect(users.size).to eq(2)
      expect(users.first.id).to eq(1)
    end

    it 'combines with :not' do
      users = finder.search(q: { not: { id: 1, name: 'user_1' } })
      expect(users.size).to eq(49)
      expect(users.first.id).to eq(2)
    end
  end

  context 'complex logic' do
    it 'combines with :and and :or' do
      users = finder.search(q: { or: [{ and: [id: 1, name: 'user_1'] }, { and: [id: 2, name: 'user_2'] }] })
      expect(users.size).to eq(2)
      expect(users.first.id).to eq(1)
    end
  end
end
