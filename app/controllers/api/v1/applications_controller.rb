module Api
 module V1
    class ApplicationsController < ApplicationController
      skip_before_action :verify_authenticity_token

      # POST /api/v1/applications
      def create
        @application = Application.new(application_params)
        @application.token = SecureRandom.uuid
        if @application.save
          render json: @application, status: :created
        else
          render json: @application.errors, status: :unprocessable_entity
        end
      rescue ActionController::ParameterMissing => e
        render json: { error: e.message }, status: :bad_request
      end

      # GET /api/v1/applications/:token
      def show
        @application = Application.find_by(token: params[:token])
        if @application
          render json: @application
        else
          render json: { error: 'Application not found' }, status: :not_found
        end
      rescue ActionController::ParameterMissing => e
        render json: { error: e.message }, status: :bad_request
      end

      def update
        @application = Application.find_by(token: params[:token])
        if @application
          if @application.update(application_params)
            render json: @application
          else
            render json: @application.errors, status: :unprocessable_entity
          end
        else
          render json: { error: 'Application not found' }, status: :not_found
        end
      rescue ActionController::ParameterMissing => e
        render json: { error: e.message }, status: :bad_request
      end

      private

      def application_params
        params.require(:application).permit(:name)
      end
    end
 end
end