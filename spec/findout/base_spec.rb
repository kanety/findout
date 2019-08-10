describe Findout::Base do
  context 'base' do
    it 'has instance method for search' do
      users = UsersFinder.new.search
      expect(users.size).to eq(50)
    end

    it 'has class method for search' do
      users = UsersFinder.search
      expect(users.size).to eq(50)
    end
  end
end
