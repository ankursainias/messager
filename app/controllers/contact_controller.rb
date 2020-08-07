class ContactController < ApplicationController
  def list
  	@users = User.not_in(_id:[ current_user.id])
  end
end
