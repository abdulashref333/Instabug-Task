module Api
  module V1
    class ChatsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        @chat = Chat.new
        @application = Application.find_by(token: params[:token])

        if @application
          application_id = @application.id
          next_chat_number = generate_next_chat_number(application_id)
          Chat::ChatCreatoinWorkerJob.perform_async(application_id, next_chat_number)

          render json: { number: next_chat_number }, status: :created
        else
          render json: { error: 'Application not found' }, status: :not_found
        end
      end

      def show
        @application = Application.find_by(token: params[:token])
        @chat = @application.chats.find_by(number: params[:number])

        if @chat
          render json: @chat
        else
          render json: { error: 'Chat not found' }, status: :not_found
        end
      end

      def index
        @application = Application.find_by(token: params[:token])
        if @application
          @chats = @application.chats
          render json: @chats
        else
          render json: { error: 'Application not found' }, status: :not_found
        end
      end

      private
      def generate_next_chat_number(application_id)
        current_chat_number = REDIS.get("next_chat_number_for_#{application_id}").to_i
        
        if current_chat_number.zero?
          REDIS.set("next_chat_number_for_#{application_id}", 1)
        else
          REDIS.incr("next_chat_number_for_#{application_id}")
        end
      end
    end
  end
end
