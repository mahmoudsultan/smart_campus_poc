class AdminController < ApplicationController
  before_action :authenticate_admin!
  def sign_up
  end
end
