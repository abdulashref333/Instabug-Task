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
          Chat::ChatCreatoinWorkerJob.perform_async(@cache_key, application_id, next_chat_number)

          render json: { number: next_chat_number }, status: :created
        else
          render json: { error: 'Application not found' }, status: :not_found
        end
      end

      def show
        application = Application.find_by(token: params[:token])
        return render json: { error: 'Application not found' }, status: :not_found unless application
        
        chat = application.chats.find_by(number: params[:number])
        if chat
          render json: chat
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
        @cache_key = Chat.get_cache_chats_number_key(application_id)
        REDIS.incr(@cache_key)
      end
    end
  end
end
