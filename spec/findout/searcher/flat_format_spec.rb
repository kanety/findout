describe Findout::Searcher do
  let :finder do
    UsersFinder.new(relation: User.order(:id))
  end

  after :example do
    debug(finder)
  end

  context 'flat format' do
    it 'converts normal format' do
      users = finder.search(q: { and: [{ col: :id, ope: :gteq, val: 1 }, { col: :id, ope: :lteq, val: 10 }] })
      expect(users.size).to eq(10)
      expect(users.first.id).to eq(1)
    end
  end
end
