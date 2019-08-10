describe Findout::Searcher do
  let :finder  do
    UsersFinder.new
  end

  after :example do
    debug(finder)
  end

  context 'query params' do
    let :finder  do
      UsersFinder.new(relation: User.order(:id))
    end

    it 'operates eq by default' do
      users = finder.search(q: { id: 1 })
      expect(users.size).to eq(1)
      expect(users.first.id).to eq(1)
    end

    it 'operates eq' do
      users = finder.search(q: { id: { eq: 1 } })
      expect(users.size).to eq(1)
      expect(users.first.id).to eq(1)
    end

    it 'operates not_eq' do
      users = finder.search(q: { id: { not_eq: 1 } })
      expect(users.size).to eq(49)
      expect(users.first.id).to eq(2)
    end

    it 'operates lt' do
      users = finder.search(q: { id: { lt: 5 } })
      expect(users.size).to eq(4)
      expect(users.last.id).to eq(4)
    end

    it 'operates lteq' do
      users = finder.search(q: { id: { lteq: 5 } })
      expect(users.size).to eq(5)
      expect(users.last.id).to eq(5)
    end

    it 'operates gt' do
      users = finder.search(q: { id: { gt: 45 } })
      expect(users.size).to eq(5)
      expect(users.first.id).to eq(46)
    end

    it 'operates gteq' do
      users = finder.search(q: { id: { gteq: 45 } })
      expect(users.size).to eq(6)
      expect(users.first.id).to eq(45)
    end

    it 'operates eq_any' do
      users = finder.search(q: { id: { eq_any: [1, 50] } })
      expect(users.size).to eq(2)
      expect(users.first.id).to eq(1)
    end

    it 'operates eq_all' do
      users = finder.search(q: { id: { eq_all: [1, 50] } })
      expect(users.size).to eq(0)
    end

    it 'operates not_eq_any' do
      users = finder.search(q: { id: { not_eq_any: [1, 50] } })
      expect(users.size).to eq(50)
      expect(users.first.id).to eq(1)
    end

    it 'operates not_eq_all' do
      users = finder.search(q: { id: { not_eq_all: [1, 50] } })
      expect(users.size).to eq(48)
      expect(users.first.id).to eq(2)
    end

    it 'operates lt_any' do
      users = finder.search(q: { id: { lt_any: [2, 49] } })
      expect(users.size).to eq(48)
      expect(users.first.id).to eq(1)
    end

    it 'operates lt_all' do
      users = finder.search(q: { id: { lt_all: [2, 49] } })
      expect(users.size).to eq(1)
      expect(users.first.id).to eq(1)
    end

    it 'operates lteq_any' do
      users = finder.search(q: { id: { lteq_any: [2, 49] } })
      expect(users.size).to eq(49)
      expect(users.first.id).to eq(1)
    end

    it 'operates lteq_all' do
      users = finder.search(q: { id: { lteq_all: [2, 49] } })
      expect(users.size).to eq(2)
      expect(users.first.id).to eq(1)
    end

    it 'operates gt_any' do
      users = finder.search(q: { id: { gt_any: [2, 49] } })
      expect(users.size).to eq(48)
      expect(users.first.id).to eq(3)
    end

    it 'operates gt_all' do
      users = finder.search(q: { id: { gt_all: [2, 49] } })
      expect(users.size).to eq(1)
      expect(users.first.id).to eq(50)
    end

    it 'operates gteq_any' do
      users = finder.search(q: { id: { gteq_any: [2, 49] } })
      expect(users.size).to eq(49)
      expect(users.first.id).to eq(2)
    end

    it 'operates gteq_all' do
      users = finder.search(q: { id: { gteq_all: [2, 49] } })
      expect(users.size).to eq(2)
      expect(users.first.id).to eq(49)
    end

    it 'operates in' do
      users = finder.search(q: { id: { in: [1, 2] } })
      expect(users.size).to eq(2)
      expect(users.first.id).to eq(1)
    end

    it 'operates not_in' do
      users = finder.search(q: { id: { not_in: [1, 2] } })
      expect(users.size).to eq(48)
      expect(users.first.id).to eq(3)
    end

    it 'operates in_any' do
      users = finder.search(q: { id: { in_any: [[1, 2], [2, 3]] } })
      expect(users.size).to eq(3)
      expect(users.first.id).to eq(1)
    end

    it 'operates in_all' do
      users = finder.search(q: { id: { in_all: [[1, 2], [2, 3]] } })
        expect(users.size).to eq(1)
      expect(users.first.id).to eq(2)
    end

    it 'operates not_in_any' do
      users = finder.search(q: { id: { not_in_any: [[1, 2], [2, 3]] } })
      expect(users.size).to eq(49)
      expect(users.first.id).to eq(1)
    end

    it 'operates not_in_all' do
      users = finder.search(q: { id: { not_in_all: [[1, 2], [2, 3]] } })
      expect(users.size).to eq(47)
      expect(users.first.id).to eq(4)
    end

    it 'operates between' do
      users = finder.search(q: { id: { between: [1, 5] } })
      expect(users.size).to eq(5)
      expect(users.first.id).to eq(1)
    end

    it 'operates not_between' do
      users = finder.search(q: { id: { not_between: [1, 5] } })
      expect(users.size).to eq(45)
      expect(users.first.id).to eq(6)
    end

    it 'operates matches' do
      users = finder.search(q: { name: { matches: 'user_10' } })
      expect(users.size).to eq(1)
      expect(users.first.name).to eq('user_10')
    end

    it 'operates does_not_match' do
      users = finder.search(q: { name: { does_not_match: 'user_10' } })
      expect(users.size).to eq(49)
      expect(users.first.name).to eq('user_1')
    end

    it 'operates matches_any' do
      users = finder.search(q: { name: { matches_any: ['user_1', 'user_2'] } })
      expect(users.size).to eq(22)
      expect(users.first.name).to eq('user_1')
    end

    it 'operates matches_all' do
      users = finder.search(q: { name: { matches_all: ['user_1', 'user_10'] } })
      expect(users.size).to eq(1)
      expect(users.first.name).to eq('user_10')
    end

    it 'operates does_not_match_any' do
      users = finder.search(q: { name: { does_not_match_any: ['user_1', 'user_10'] } })
      expect(users.size).to eq(49)
      expect(users.first.name).to eq('user_1')
    end

    it 'operates does_not_match_all' do
      users = finder.search(q: { name: { does_not_match_all: ['user_1', 'user_2'] } })
      expect(users.size).to eq(28)
      expect(users.first.name).to eq('user_3')
    end

    it 'operates word_any' do
      users = finder.search(q: { name: { word_any: 'user_1 user_2' } })
      expect(users.size).to eq(22)
      expect(users.first.name).to eq('user_1')
    end

    it 'operates word_all' do
      users = finder.search(q: { name: { word_all: 'user_1 user_10' } })
      expect(users.size).to eq(1)
      expect(users.first.name).to eq('user_10')
    end
  end

  context 'sort params' do
    it 'operates asc by default' do
      users = finder.search(s: [ :id ])
      expect(users.first.id).to eq(1)
    end

    it 'operates asc' do
      users = finder.search(s: { id: :asc })
      expect(users.first.id).to eq(1)
    end

    it 'operates desc' do
      users = finder.search(s: { id: :desc })
      expect(users.first.id).to eq(50)
    end
  end
end
