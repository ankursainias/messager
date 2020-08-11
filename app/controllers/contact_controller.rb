class ContactController < ApplicationController
	before_action :authenticate_user!
  def list
  	@users = User.not_in(_id:[ current_user.id])
  end
end
