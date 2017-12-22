require 'rails_helper'

describe ProductsController do
  render_views

  describe 'GET #index' do
    context 'when no filters are present' do
      before(:each) do
        Fabricate.times(3, :product)
        get :index, format: :json
        @resp = JSON.parse(response.body)
      end

      it 'should show 3 products' do
        expect(@resp.count).to eql(3)
      end
    end

    context 'when no products are present' do
      before(:each) do
        get :index, format: :json
        @resp = JSON.parse(response.body)
      end

      it 'should show no products' do
        expect(@resp.count).to eql(0)
      end
    end

    context 'when filters are present' do
      context 'when filtering is done for one category' do
        before(:each) do
          products = Fabricate.times(3, :product)
          category = Fabricate(:category)
          products.first.categories << category
          products.first.save!
          subcategory = Fabricate(:category)
          subcategory.parent_id = category.id
          subcategory.save!
          products.last.categories << subcategory
          products.last.save!
          get :index, product: { category_ids: [category.id]}, format: :json
          @resp = JSON.parse(response.body)
        end

        it 'should show products from category and subcategory' do
          expect(@resp.count).to eql(2)
        end
      end

      context 'when filtering is done for two categories' do
        before(:each) do
          products = Fabricate.times(3, :product)
          category_1 = Fabricate(:category)
          products.first.categories << category_1
          products.first.save!
          category_2 = Fabricate(:category)
          products.last.categories << category_2
          products.last.save!
          get :index, product: { category_ids: [category_1.id, category_2.id]}, format: :json
          @resp = JSON.parse(response.body)
        end

        it 'should show products from category_1 and category_2' do
          expect(@resp.count).to eql(2)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'when all parameters are present' do
      before(:each) do
        post :create, product: { name: 'Sephora', description: 'Sephora', price: 100 }, format: :json
        @resp = JSON.parse(response.body)
      end

      it 'should create product with name Sephora' do
        expect(@resp['name']).to eql('Sephora')
      end
    end

    context 'when category_ids is present' do
      before(:each) do
        @category = Fabricate(:category)
        post :create, product: { name: 'Sephora_2', description: 'Sephora_2', price: 100, category_ids: [@category.id] }, format: :json
        @resp = JSON.parse(response.body)
      end

      it 'should create product with name Sephora_2' do
        expect(@resp['name']).to eql('Sephora_2')
      end

      it 'should belong to category' do
        expect(Product.find(@resp['id']).categories.first.id).to eql(@category.id)
      end
    end

    context 'when category_ids are present' do
      before(:each) do
        @category_1 = Fabricate(:category)
        @category_2 = Fabricate(:category)
        post :create, product: { name: 'Sephora_3', description: 'Sephora_3', price: 100, category_ids: [@category_1.id, @category_2.id] }, format: :json
        @resp = JSON.parse(response.body)
      end

      it 'should create product with name Sephora_3' do
        expect(@resp['name']).to eql('Sephora_3')
      end

      it 'should belong to category_1' do
        expect(Product.find(@resp['id']).categories.first.id).to eql(@category_1.id)
      end

      it 'should belong to category_1' do
        expect(Product.find(@resp['id']).categories.last.id).to eql(@category_2.id)
      end
    end
  end
end