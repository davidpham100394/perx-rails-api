# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < ApplicationController
      skip_before_action :verify_authenticity_token
      def single
        transaction = Transaction.new(transaction_params)

        if transaction.save
          render json: { status: 'success', transaction_id: transaction.transaction_id }, status: :created
        else
          render json: { status: 'error', errors: transaction.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def bulk
        transactions = Transaction.create(bulk_transaction_params[:transactions])
        if transactions.all?(&:persisted?)
          render json: { status: 'success', processed_count: transactions.size }, status: :created
        else
          render json: { status: 'error', errors: transactions.map(&:errors).map(&:full_messages) },
                 status: :unprocessable_entity
        end
      end

      private

      def transaction_params
        params.require(:transaction).permit(:transaction_id, :points, :user_id)
      end

      def bulk_transaction_params
        params.permit(transactions: %i[transaction_id points user_id])
      end
    end
  end
end
