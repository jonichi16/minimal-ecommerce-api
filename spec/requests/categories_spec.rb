require "rails_helper"

RSpec.describe "Categories" do
  let(:admin) { create(:admin) }
  let(:tokens) { jwt_and_refresh_token(admin, "admin") }
  let(:category) { create(:category, name: "Sofa") }

  describe "GET /api/v1/categories" do
    before do
      create_list(:category, 8)
    end

    context "with valid tokens" do
      it "returns ok status" do
        get "/api/v1/categories", headers: {
          Authorization: "Bearer #{tokens[0]}"
        }

        expect(response).to have_http_status(:ok)
        expect(json.size).to eq(8)
      end
    end

    context "with invalid tokens" do
      it "returns unauthorized status" do
        get "/api/v1/categories", headers: {
          Authorization: "invalidtoken"
        }

        expect(response).to have_http_status(:unauthorized)
        expect(json["error"]).to eq("Invalid access token")
      end
    end
  end

  describe "POST /api/v1/categories" do
    context "with valid tokens" do
      it "returns created status" do
        post "/api/v1/categories", headers: {
          Authorization: "Bearer #{tokens[0]}"
        }, params: {
          category: {
            name: "Sofa"
          }
        }

        expect(response).to have_http_status(:created)
        expect(json["data"]["name"]).to eq("Sofa")
      end
    end

    context "with invalid tokens" do
      it "returns unauthorized status" do
        post "/api/v1/categories", headers: {
          Authorization: "invalidtoken"
        }, params: {
          category: {
            name: "Sofa"
          }
        }

        expect(response).to have_http_status(:unauthorized)
        expect(json["error"]).to eq("Invalid access token")
      end
    end
  end

  describe "GET /api/v1/categories/:id" do
    context "with valid tokens" do
      it "returns ok status" do
        get "/api/v1/categories/#{category.id}", headers: {
          Authorization: "Bearer #{tokens[0]}"
        }

        expect(response).to have_http_status(:ok)
        expect(json["data"]["name"]).to eq(category.name)
      end
    end

    context "when id is not available" do
      it "returns not found status" do
        get "/api/v1/categories/99999999999", headers: {
          Authorization: "Bearer #{tokens[0]}"
        }

        expect(response).to have_http_status(:not_found)
      end
    end

    context "with invalid tokens" do
      it "returns unauthorized status" do
        get "/api/v1/categories/#{category.id}", headers: {
          Authorization: "invalidtoken"
        }

        expect(response).to have_http_status(:unauthorized)
        expect(json["error"]).to eq("Invalid access token")
      end
    end
  end

  describe "PATCH /api/v1/categories/:id" do
    it "returns ok status" do
      patch "/api/v1/categories/#{category.id}", headers: {
        Authorization: "Bearer #{tokens[0]}"
      }, params: {
        category: {
          name: "Bed"
        }
      }

      expect(response).to have_http_status(:ok)
      expect(json["data"]["name"]).to eq("Bed")
    end
  end

  describe "DELETE /api/v1/categories/:id" do
    it "returns ok status" do
      delete "/api/v1/categories/#{category.id}", headers: {
        Authorization: "Bearer #{tokens[0]}"
      }

      expect(response).to have_http_status(:ok)
      expect(Category.all).not_to include("Sofa")
    end
  end
end
