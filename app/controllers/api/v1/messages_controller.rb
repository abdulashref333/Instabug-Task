module Api
  module V1
    class MessagesController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        @cache_key = nil
        begin
          chat_id, application_id = validate_application_and_chat
          next_message_number = generate_next_message_number(application_id, chat_id)
          Message::MessageCreatoinWorkerJob.perform_async(@cache_key, chat_id, next_message_number, message_params[:body])

          render json: { number: next_message_number }, status: :created
        rescue ActiveRecord::RecordNotFound => e
          render json: { error: e }, status: :not_found
        end

      rescue ActionController::ParameterMissing => e
        REDIS.decr(@cache_key) if @cache_key
        render json: { error: I18n.t('controllers.errors.parameter_missing', model: "Message", param: "body") }, status: :bad_request
      end

      def update
        begin
          chat_id, application_id = validate_application_and_chat
          message = Message.where(chat_id:, number: params[:message_number]).first
          return render json: { error: I18n.t('controllers.errors.not_found', model: 'Message') }, status: :not_found unless message

          message.update(body: message_params[:body])
          render json: message, status: :ok
        rescue => e
          render json: { error: e }, status: :not_found
        end
      end

      def show
        begin
          chat_id, _ = validate_application_and_chat
          message = Message.where(chat_id:, number: params[:message_number]).first
          return render json: { error: I18n.t('controllers.errors.not_found', model: 'Message') }, status: :not_found unless message

          render json: message
        rescue => e
          render json: { error: e }, status: :not_found
        end

      end

      def index
        begin
          chat_id, _ = validate_application_and_chat
          messages = Message.where(chat_id: chat_id).order(number: :asc)
          render json: messages
        rescue => e
          render json: { error: e }, status: :not_found
        end
      end

      def search
        begin
          chat_id, _ = validate_application_and_chat
          query = params[:query]
          response = Message.search(query, chat_id)
          render json: response.map { |message| message._source.except("chat_id") }
        rescue => e
          render json: { error: e }, status: :not_found
        end
      end

      private

      def generate_next_message_number(application_id, chat_id)
        @cache_key = Message.get_chach_messages_number_key(application_id, chat_id)
        REDIS.incr(@cache_key)
      end

      def message_params
        params.require(:message).permit(:body)
      end

      def validate_application_and_chat
        application_id = Application.where(token: params[:token]).select(:id)&.first&.id
        raise ActiveRecord::RecordNotFound,I18n.t('controllers.errors.not_found', model: 'Application') unless application_id
        
        chat_id = Chat.where(number: params[:number], application_id:).select(:id)&.first&.id
        raise ActiveRecord::RecordNotFound, I18n.t('controllers.errors.not_found', model: 'Chat') unless chat_id

        [chat_id, application_id]
      end
    end
  end
end
