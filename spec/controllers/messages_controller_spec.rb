require "rails_helper"

RSpec.describe "Api::V1::MessagesController", type: :request do

  let(:application) { create(:application) }
  let(:chat) { create(:chat, application: application) }
  let(:message_body) { { body: "test message body" } }
  let(:valid_url) { "/api/v1/applications/#{application.token}/chats/#{chat.number}/messages" }

  describe "POST /api/v1/applications/:token/chats/:number/messages" do
    context "with valid params" do
      it "creates a new message" do
        post valid_url, params: { message: message_body }
        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)).to include("number")
      end
    end

    context "with invalid params" do
      it "returns param is missing" do
        post valid_url, params: { message: {} }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to have_key("error")
        expect(JSON.parse(response.body)["error"]).to include(I18n.t('controllers.errors.parameter_missing', model: "Message", param: "body"))
      end
    end

    context "with invalid chat number" do
      it "returns Chat not found" do
        post "/api/v1/applications/#{application.token}/chats/-1/messages"
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to have_key("error")
        expect(JSON.parse(response.body)["error"]).to include(I18n.t('controllers.errors.not_found', model: 'Chat'))
      end
    end

    context "with invalid application token" do
      it "returns Application not found" do
        post "/api/v1/applications/invalid_token/chats/invalid_number/messages"
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to have_key("error")
        expect(JSON.parse(response.body)["error"]).to include(I18n.t('controllers.errors.not_found', model: 'Application'))
      end
    end

    context "with invalid message body" do
      it "returns Message not created" do
        post valid_url, params: { message: { } }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to have_key("error")
        expect(JSON.parse(response.body)["error"]).to include(I18n.t('controllers.errors.parameter_missing', model: "Message", param: "body"))
      end
    end
  end

  describe "GET /api/v1/applications/:token/chats/:number/messages" do
    context "with valid params" do
      it "returns the messages" do
        message = create :message, chat: chat

        get valid_url
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body)[0]["number"]).to eq(message.number)
        expect(JSON.parse(response.body)[0]["body"]).to eq(message.body)
      end
    end

    context "with invalid chat number" do
      it "returns Chat not found" do
        get "/api/v1/applications/#{application.token}/chats/-1/messages"
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to have_key("error")
        expect(JSON.parse(response.body)["error"]).to include(I18n.t('controllers.errors.not_found', model: 'Chat'))
      end
    end
  end

  describe "PATCH /api/v1/applications/:token/chats/:number/messages/:number" do
    context "with valid params" do
      it "updates the message" do
        message = create :message, chat: chat

        patch "/api/v1/applications/#{application.token}/chats/#{chat.number}/messages/#{message.number}", params: { message: { body: "updated message body" } }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["body"]).to eq("updated message body")
      end
    end

    context "with invalid chat number" do
      it "returns Chat not found" do
        patch "/api/v1/applications/#{application.token}/chats/-1/messages/1"
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to have_key("error")
        expect(JSON.parse(response.body)["error"]).to include(I18n.t('controllers.errors.not_found', model: 'Chat'))
      end
    end
  end

  describe "GET /api/v1/applications/:token/chats/:number/messages/:number" do
    context "with valid params" do
      it "returns the message" do
        message = create :message, chat: chat

        get "/api/v1/applications/#{application.token}/chats/#{chat.number}/messages/#{message.number}"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["number"]).to eq(message.number)
        expect(JSON.parse(response.body)["body"]).to eq(message.body)
      end
    end

    context "with invalid message number" do
      it "returns Message not found" do
        get "#{valid_url}/-1"
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to have_key("error")
        expect(JSON.parse(response.body)["error"]).to include(I18n.t('controllers.errors.not_found', model: 'Message'))
      end
    end
  end
end