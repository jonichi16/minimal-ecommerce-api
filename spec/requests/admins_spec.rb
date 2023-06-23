require "rails_helper"

RSpec.describe "Admins" do
  describe "POST /admins/sign_up" do
    context "with valid attributes" do
      it "returns ok status" do
        post "/admins/sign_up", params: {
          registration: {
            email: "admin@test.com",
            password: "password",
            password_confirmation: "password"
          }
        }

        expect(response).to have_http_status(:ok)
        expect(response["Access-Token"]).not_to be_nil
        expect(json["status"]).to eq("success")
      end
    end

    context "with invalid attributes" do
      it "returns unprocessable entity status" do
        post "/admins/sign_up", params: {
          registration: {
            email: "admin@test.com",
            password: "password",
            password_confirmation: "otherpassword"
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response["Access-Token"]).to be_nil
        expect(json["error"]).to eq("Password confirmation doesn't match Password")
      end
    end
  end

  describe "POST /admins/sign_in" do
    let(:admin) { create(:admin) }

    context "with valid credentials" do
      it "returns ok status" do
        post "/admins/sign_in", params: {
          email: admin.email,
          password: admin.password
        }

        expect(response).to have_http_status(:ok)
        expect(response["Access-Token"]).not_to be_nil
        expect(json["status"]).to eq("success")
      end
    end

    context "with invalid credentials" do
      it "returns unprocessable entity status" do
        post "/admins/sign_in", params: {
          email: admin.email,
          password: "wrongpassword"
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response["Access-Token"]).to be_nil
        expect(json["error"]).to eq("Invalid login credentials")
      end
    end
  end

  describe "DELETE /admins/sign_out" do
    let(:admin) { create(:admin) }

    context "with valid token" do
      it "returns ok status" do
        tokens = jwt_and_refresh_token(admin, "admin")

        delete "/admins/sign_out", headers: {
          Authorization: "Bearer #{tokens[0]}"
        }

        expect(response).to have_http_status(:ok)
        expect(response["Access-Token"]).to be_nil
        expect(json["status"]).to eq("success")
      end
    end

    context "with invalid token" do
      it "returns unauthorized status" do
        delete "/admins/sign_out", headers: {
          Authorization: "invalidauthorizationtoken"
        }

        expect(response).to have_http_status(:unauthorized)
        expect(json["error"]).to eq("Invalid access token")
      end
    end
  end

  describe "POST /admins/tokens" do
    let(:admin) { create(:admin) }
    let(:tokens) { jwt_and_refresh_token(admin, "admin") }

    context "with valid token" do
      it "returns ok status" do
        post "/admins/tokens", headers: {
          Authorization: "Bearer #{tokens[0]}",
          "Refresh-Token": tokens[1]
        }

        expect(response).to have_http_status(:ok)
        expect(json["status"]).to eq("success")
      end
    end

    context "with invalid token" do
      it "returns unauthorized status" do
        post "/admins/tokens", headers: {
          Authorization: "Bearer #{tokens[0]}",
          "Refresh-Token": "invalidrefreshtoken"
        }

        expect(response).to have_http_status(:unauthorized)
        expect(json["error"]).to eq("Invalid refresh token")
      end
    end
  end

  describe "PATCH /admins/passwords" do
    let(:admin) { create(:admin) }
    let(:tokens) { jwt_and_refresh_token(admin, "admin") }

    context "with valid tokens" do
      it "returns ok status" do
        patch "/admins/passwords", headers: {
          Authorization: "Bearer #{tokens[0]}"
        }, params: {
          password: "new_password",
          password_confirmation: "new_password"
        }

        expect(response).to have_http_status(:ok)
        expect(json["status"]).to eq("success")
      end
    end

    context "with invalid tokens" do
      it "returns unauthorized status" do
        patch "/admins/passwords", headers: {
          Authorization: "invalidaccesstoken"
        }, params: {
          password: "new_password",
          password_confirmation: "new_password"
        }

        expect(response).to have_http_status(:unauthorized)
        expect(json["error"]).to eq("Invalid access token")
      end
    end

    context "with invalid password confirmation" do
      it "returns unprocessable entity status" do
        patch "/admins/passwords", headers: {
          Authorization: "Bearer #{tokens[0]}"
        }, params: {
          password: "new_password",
          password_confirmation: "other_password"
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["error"]).to eq("Password confirmation doesn't match Password")
      end
    end
  end
end
