# frozen_string_literal: true

require "rails_helper"

describe Ajax::MuteRuleController, :ajax_controller, type: :controller do
  describe "#create" do
    subject { post(:create, params:) }

    context "when user is signed in" do
      before(:each) { sign_in(user) }

      let(:params) { { muted_phrase: "test" } }
      let(:expected_response) do
        {
          "success" => true,
          "status"  => "okay",
          "id"      => MuteRule.last.id.to_s,
          "message" => "Rule added successfully."
        }
      end

      it "creates a mute rule" do
        expect { subject }.to change { MuteRule.count }.by(1)
        expect(response).to have_http_status(:success)

        rule = MuteRule.first
        expect(rule.user_id).to eq(user.id)
        expect(rule.muted_phrase).to eq("test")
      end

      include_examples "returns the expected response"
    end
  end

  describe "#update" do
    subject { post(:update, params:) }

    context "when user is signed in" do
      before(:each) { sign_in(user) }

      let(:rule) { MuteRule.create(user:, muted_phrase: "test") }
      let(:params) { { id: rule.id, muted_phrase: "dogs" } }
      let(:expected_response) do
        {
          "success" => true,
          "status"  => "okay",
          "message" => "Rule updated successfully."
        }
      end

      it "updates a mute rule" do
        subject
        expect(response).to have_http_status(:success)

        expect(rule.reload.muted_phrase).to eq("dogs")
      end

      include_examples "returns the expected response"
    end
  end

  describe "#destroy" do
    subject { delete(:destroy, params:) }

    context "when user is signed in" do
      before(:each) { sign_in(user) }

      let(:rule) { MuteRule.create(user:, muted_phrase: "test") }
      let(:params) { { id: rule.id } }
      let(:expected_response) do
        {
          "success" => true,
          "status"  => "okay",
          "message" => "Rule deleted successfully."
        }
      end

      it "deletes a mute rule" do
        subject
        expect(response).to have_http_status(:success)

        expect(MuteRule.exists?(rule.id)).to eq(false)
      end

      include_examples "returns the expected response"
    end
  end
end
