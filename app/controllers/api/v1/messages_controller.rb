module Api
  module V1
    class MessagesController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        begin
          chat_id, application_id, chat_number = validate_application_and_chat
          next_chat_number = generate_next_message_number(application_id, chat_number)
          Message::MessageCreatoinWorkerJob.perform_async(chat_id, next_chat_number, message_params[:body])
          render json: { number: next_chat_number }, status: :created
        rescue => e
          render json: { error: e }, status: :not_found
        end
      end

      def update
        begin
          chat_id, application_id, chat_number = validate_application_and_chat
          message = Message.where(chat_id:, number: params[:message_number]).first
          return render json: { error: 'Message not found' }, status: :not_found unless message

          message.update(body: message_params[:body])
          render json: message, status: :ok
        rescue => e
          render json: { error: e }, status: :not_found
        end
      end

      def show
        begin
          chat_id, _, _ = validate_application_and_chat
          message = Message.where(chat_id:, number: params[:message_number]).first
          return render json: { error: 'Message not found' }, status: :not_found unless message

          render json: message
        rescue => e
          render json: { error: e }, status: :not_found
        end

      end

      def index
        begin
          chat_id, _, _ = validate_application_and_chat
          messages = Message.where(chat_id: chat_id).order(number: :asc)
          render json: messages
        rescue => e
          render json: { error: e }, status: :not_found
        end
      end

      def search
        begin
          chat_id, _, _ = validate_application_and_chat
          query = params[:query]
          response = Message.search(query, chat_id)
          render json: response.map { |message| message._source.except("chat_id") }
        rescue => e
          render json: { error: e }, status: :not_found
        end
      end
      private
      def generate_next_message_number(application_id, chat_number)
        current_chat_number = REDIS.get("next_message_number_for_#{application_id}_and_#{chat_number}").to_i
        
        if current_chat_number.zero?
          REDIS.set("next_message_number_for_#{application_id}_and_#{chat_number}", 1)
          return 1
        else
          REDIS.incr("next_message_number_for_#{application_id}_and_#{chat_number}")
        end
      end

      def message_params
        params.require(:message).permit(:body)
      end

      def validate_application_and_chat
        application_id = Application.where(token: params[:token]).select(:id)&.first&.id
        raise 'Application not found' unless application_id
        
        chat = Chat.where(number: params[:number], application_id:).select(:id, :number)&.first
        raise 'Chat not found' unless chat

        chat_id = chat.id
        chat_number = chat.number
        [chat_id, application_id, chat_number]
      end
    end
  end
end
