# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  describe 'POST #single' do
    context 'with valid attributes' do
      it 'creates a new transaction' do
        post :single, params: { transaction: { transaction_id: '123', points: 100, user_id: 'user_1' } }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['status']).to eq('success')
      end
    end

    context 'with invalid attributes' do
      it 'returns an error' do
        post :single, params: { transaction: { points: 100, user_id: 'user_1' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']).to eq('error')
      end
    end
  end

  describe 'POST #bulk' do
    context 'with valid attributes' do
      it 'creates multiple transactions' do
        transactions_params = {
          transactions: [
            { transaction_id: '123', points: 100, user_id: 'user_1' },
            { transaction_id: '124', points: 200, user_id: 'user_2' }
          ]
        }
        post :bulk, params: transactions_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['status']).to eq('success')
        expect(JSON.parse(response.body)['processed_count']).to eq(2)
      end
    end

    context 'with invalid attributes' do
      it 'returns an error' do
        transactions_params = {
          transactions: [
            { points: 100, user_id: 'user_1' },
            { transaction_id: '124', points: 200 }
          ]
        }
        post :bulk, params: transactions_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']).to eq('error')
      end
    end
  end
end
