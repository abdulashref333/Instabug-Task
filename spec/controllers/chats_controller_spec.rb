require "rails_helper"

RSpec.describe "Api::V1::ChatsController", type: :request do

  describe "POST /api/v1/applications/:token/chats" do
    context "with valid params" do
      let(:application) { create(:application) }

      it "creates a new chat" do
        post "/api/v1/applications/#{application.token}/chats"
        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)).to include("number")
      end
    end

    context "with invalid params" do
      it "returns unprocessable entity" do
        post "/api/v1/applications/invalid_token/chats"
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to have_key("error")
      end
    end
  end

  describe "GET /api/v1/applications/:token/chats/:number" do
    let(:application) { create(:application) }
    context "with valid params" do
      let(:chat) { create(:chat, application: application) }

      it "returns the chat" do
        get "/api/v1/applications/#{application.token}/chats/#{chat.number}"

        res_body = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(res_body["number"]).to eq(chat.number)
        expect(res_body["messages_count"]).to eq(chat.messages_count)
      end
    end

    context "with invalid params" do
      it "returns Chat not found" do
        get "/api/v1/applications/#{application.token}/chats/invalid_number"

        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to have_key("error")
        expect(JSON.parse(response.body)["error"]).to eq("Chat not found")
      end

      it "returns Application not found" do
        get "/api/v1/applications/invalid_token/chats/invalid_number"

        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to have_key("error")
        expect(JSON.parse(response.body)["error"]).to eq("Application not found")
      end
    end
  end

  describe "GET /api/v1/applications/:token/chats" do
    context "with valid params" do
      let(:application) { create(:application) }

      it "returns the chats" do
        get "/api/v1/applications/#{application.token}/chats"

        res_body = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(res_body.count).to eq(application.chats.count)
      end
    end

    context "with invalid params" do
      it "returns Application not found" do
        get "/api/v1/applications/invalid_token/chats"

        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to have_key("error")
        expect(JSON.parse(response.body)["error"]).to eq("Application not found")
      end
    end
  end
end