module Slickr
  module SlickrAdminUser

    def self.included(base)
      base.class_eval do
        include Slickr::Uploadable

        # Include default devise modules. Others available are:
        # :confirmable, :lockable, :timeoutable and :omniauthable
        devise :database_authenticatable,
               :recoverable, :rememberable, :trackable, :validatable

        has_one_slickr_upload(:slickr_admin_user_avatar, :admin_user_avatar)
        has_many :slickr_event_logs

        def display_name
          first_name.present? ? first_name : email
        end

        def full_name
          [first_name, last_name].join(' ')
        end

        def admin?
          role == 'admin'
        end

        def editor?
          role == 'editor'
        end

        def author?
          role == 'author'
        end

        def days_since_last_login
          (DateTime.now.to_date - last_sign_in_at.to_date).to_i
        end
      end
    end
  end
end
