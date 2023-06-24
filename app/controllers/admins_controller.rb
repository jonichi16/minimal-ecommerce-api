class AdminsController < ApplicationController
  before_action :authenticate_and_set_admin

  def profile
    render json: {
      status: "success",
      message: "Authenticated",
      data: AdminSerializer.new(@current_admin).serializable_hash[:data][:attributes]
    }
  end
end
