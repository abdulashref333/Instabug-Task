require "rails_helper"

RSpec.describe "Api::V1::ApplicationsController", type: :request do

  describe "POST /api/v1/applications" do
    context "with valid params" do
      let(:valid_params) { { application: { name: "My App" } } }

      it "creates a new application" do
        post "/api/v1/applications", params: valid_params
        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)).to include("token")
      end
    end

    context "with invalid params" do
      let(:invalid_params) { {} }

      it "returns unprocessable entity" do
        post "/api/v1/applications", params: invalid_params
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to have_key("error")
        expect(JSON.parse(response.body)["error"]).to include(I18n.t('controllers.errors.parameter_missing', model: "Application", param: "name"))
      end
    end
  end

  describe "GET /api/v1/applications/:token" do
    context "with valid token" do
      let(:application) { create(:application) }

      it "returns the application" do
        get "/api/v1/applications/#{application.token}"

        res_body = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(res_body["token"]).to include(application.token)
        expect(res_body["name"]).to include(application.name)
        expect(res_body["chats_count"]).to eq(application.chats_count)
      end
    end

    context "with invalid token" do
      it "returns not found" do
        get "/api/v1/applications/invalid_token"

        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to have_key("error")
        expect(JSON.parse(response.body)["error"]).to include(I18n.t('controllers.errors.not_found', model: 'Application'))
      end
    end
  end

  describe "PATCH /api/v1/applications/:token" do
    context "with valid params" do
      let(:application) { create(:application) }
      let(:updated_name) { "Updated Name" }

      it "updates the application" do
        patch "/api/v1/applications/#{application.token}", params: { application: { name: updated_name } }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["name"]).to eq(updated_name)
      end
    end

    context "with invalid params" do
      let(:application) { create(:application) }

      it "returns unprocessable entity" do
        patch "/api/v1/applications/#{application.token}", params: { application: { name: "" } }

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to have_key("name")
        expect(JSON.parse(response.body)["name"]).to include("can't be blank")
      end
    end
  end
end
