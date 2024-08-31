# frozen_string_literal: true

# spec/integration/api/v1/transactions_spec.rb

require 'swagger_helper'

RSpec.describe 'api/v1/transactions', type: :request do
  path '/api/v1/transactions/single' do
    post 'Creates a transaction' do
      tags 'Transactions'
      consumes 'application/json'
      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          transaction_id: { type: :string },
          points: { type: :integer },
          user_id: { type: :string }
        },
        required: %w[transaction_id points user_id]
      }

      response '201', 'transaction created' do
        let(:transaction) { { transaction_id: '123', points: 100, user_id: 1 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:transaction) { { transaction_id: '123', points: nil, user_id: 1 } }
        run_test!
      end
    end
  end

  path '/api/v1/transactions/bulk' do
    post 'Creates multiple transactions' do
      tags 'Transactions'
      consumes 'application/json'
      parameter name: :transactions, in: :body, schema: {
        type: :object,
        properties: {
          transactions: {
            type: :array,
            items: {
              type: :object,
              properties: {
                transaction_id: { type: :string },
                points: { type: :integer },
                user_id: { type: :string }
              },
              required: %w[transaction_id points user_id]
            }
          }
        },
        required: ['transactions']
      }

      response '201', 'transactions created' do
        let(:transactions) { { transactions: [{ transaction_id: '123', points: 100, user_id: 1 }] } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:transactions) { { transactions: [{ transaction_id: '123', points: nil, user_id: 1 }] } }
        run_test!
      end
    end
  end
end
