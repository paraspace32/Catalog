require 'rails_helper'

describe CategoriesController do
  render_views

  describe 'GET #index' do
    context 'when categories are present' do
      before(:each) do
        Fabricate.times(3, :category)
        get :index, format: :json
        @resp = JSON.parse(response.body)
      end

      it 'should show 3 products' do
        expect(@resp.count).to eql(3)
      end
    end

    context 'when no categories are present' do
      before(:each) do
        get :index, format: :json
        @resp = JSON.parse(response.body)
      end

      it 'should show no products' do
        expect(@resp.count).to eql(0)
      end
    end
  end

  describe 'POST #create' do
    context 'when all parameters are present' do
      before(:each) do
        post :create, category: { name: 'Cosmetic' }, format: :json
        @resp = JSON.parse(response.body)
      end

      it 'should create category with name Cosmetic' do
        expect(@resp['name']).to eql('Cosmetic')
      end
    end

    context 'when subcategory is created' do
      before(:each) do
        @category = Fabricate(:category)
        post :create, category: { name: 'Cosmetic_2', parent_id: @category.id }, format: :json
        @resp = JSON.parse(response.body)
      end

      it 'should create subcategory with name Cosmetic_2' do
        expect(@resp['name']).to eql('Cosmetic_2')
      end

      it 'should create subcategory with parent category' do
        expect(@resp['parent_id']).to eql(@category.id)
      end
    end
  end
end