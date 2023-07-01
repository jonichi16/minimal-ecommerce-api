require "rails_helper"

RSpec.describe "Products" do
  let(:admin) { create(:admin) }
  let(:tokens) { jwt_and_refresh_token(admin, "admin") }
  let(:category) { create(:category, name: "Sofa") }
  let(:product) { create(:product, name: "Red Sofa", category:, price: 1299.99, quantity: 60) }

  describe "GET /api/v1/categories/:category_id/products" do
    before do
      create_list(:product, 6, category:)
    end

    context "with valid tokens" do
      it "returns ok status" do
        get "/api/v1/categories/#{category.id}/products", headers: {
          Authorization: "Bearer #{tokens[0]}"
        }

        expect(response).to have_http_status(:ok)
        expect(json.size).to eq(6)
      end
    end

    context "with invalid tokens" do
      it "returns unauthorized status" do
        get "/api/v1/categories/#{category.id}/products", headers: {
          Authorization: "invalidtoken"
        }

        expect(response).to have_http_status(:unauthorized)
        expect(json["error"]).to eq("Invalid access token")
      end
    end
  end

  describe "POST /api/v1/categories/:category_id/products" do
    context "with valid tokens" do
      it "returns created status" do
        post "/api/v1/categories/#{category.id}/products", headers: {
          Authorization: "Bearer #{tokens[0]}"
        }, params: {
          product: {
            name: "Blue Sofa",
            description: "A blue sofa",
            price: 125.99,
            quantity: 50
          }
        }

        expect(response).to have_http_status(:created)
        expect(json["data"]["name"]).to eq("Blue Sofa")
        expect(json["data"]["price"]).to eq("125.99")
      end
    end
  end

  describe "GET /api/v1/categories/:category_id/products/:id" do
    context "with valid tokens" do
      it "returns ok status" do
        get "/api/v1/categories/#{category.id}/products/#{product.id}", headers: {
          Authorization: "Bearer #{tokens[0]}"
        }

        expect(response).to have_http_status(:ok)
        expect(json["data"]["name"]).to eq(product.name)
        expect(json["data"]["price"]).to eq(product.price.to_s)
      end
    end

    context "when id is not available" do
      it "returns not found status" do
        get "/api/v1/categories/#{category.id}/products/99999999999", headers: {
          Authorization: "Bearer #{tokens[0]}"
        }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH /api/v1/categories/:category_id/products/:id" do
    it "returns ok status" do
      patch "/api/v1/categories/#{category.id}/products/#{product.id}", headers: {
        Authorization: "Bearer #{tokens[0]}"
      }, params: {
        product: {
          name: "Light Sofa",
          price: 999
        }
      }

      expect(response).to have_http_status(:ok)
      expect(json["data"]["name"]).to eq("Light Sofa")
      expect(json["data"]["price"]).to eq("999.0")
    end
  end

  describe "DELETE /api/v1/categories/:category_id/products/:id" do
    it "returns ok status" do
      delete "/api/v1/categories/#{category.id}/products/#{product.id}", headers: {
        Authorization: "Bearer #{tokens[0]}"
      }

      expect(response).to have_http_status(:ok)
      expect(Product.all).not_to include("Red Sofa")
    end
  end
end
