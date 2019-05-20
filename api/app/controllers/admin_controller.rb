class AdminController < ApplicationController
  before_action :authenticate_admin!, only: [:create_user]
  
  def create_user
    @user = User.new(params[:user])
    if @user.save
      # ...
    else
      flash.now[:error] = "Could not create new user"
      render action: "new"
    end
  end

end
