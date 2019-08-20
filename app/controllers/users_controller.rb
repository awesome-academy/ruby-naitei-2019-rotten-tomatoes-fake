class UsersController < ApplicationController
  before_action :load_user, only: :show

  def show
    @user = User.find_by id: params[:id]
  end

  private

  def load_user
    @user = User.find_by id: params[:id]

    return if @user
    redirect_to root_url
  end


end
