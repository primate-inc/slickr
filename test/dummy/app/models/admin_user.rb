class AdminUser < ApplicationRecord
  include Slickr::SlickrAdminUser
  ROLES = [:admin, :editor, :author, :contributor]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
end
