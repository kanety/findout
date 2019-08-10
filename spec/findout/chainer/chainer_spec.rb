describe Findout::Chainer do
  let :finder do
    UsersFinder.new
  end

  after :example do
    debug(finder)
  end

  context 'chainer' do
    it 'chains method' do
      users = finder.search(q: { name_param: 'user_10' })
      expect(users.size).to eq(1)
      expect(users.first.id).to eq(10)
    end

    it 'chains proc' do
      users = finder.search(q: { title_param: 'USER_10' })
      expect(users.size).to eq(1)
      expect(users.first.id).to eq(10)
    end
  end
end
