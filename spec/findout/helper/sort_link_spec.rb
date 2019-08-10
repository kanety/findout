describe UsersController, type: :request do
  context 'sort link' do
    it 'orders asc by default' do
      get users_path
      expect(response.body).to include("users?" + { s: { id: :asc } }.to_query)
    end

    context 'initially asc' do
      it 'orders asc' do
        get users_path params: { s: [ id: :asc ] }
        expect(response.body).to include("users?" + { s: [ id: :desc ] }.to_query)
      end

      it 'orders desc' do
        get users_path params: { s: [ id: :desc ] }
        expect(response.body).to include("users?" + { s: [ id: :asc ] }.to_query)
      end
    end

    context 'initially desc' do
      it 'orders asc' do
        get users_path params: { s: [ name: :asc ] }
        expect(response.body).to include("users?" + { s: [ name: :desc ] }.to_query)
      end

      it 'orders desc' do
        get users_path params: { s: [ name: :desc ] }
        expect(response.body).to include("users?" + { s: [ name: :asc ] }.to_query)
      end
    end
  end
end
