class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= AdminUser.new

    if user.admin?
      can :manage, :all
    elsif user.editor?
      can :manage, Slickr::Page
      can :read, AdminUser
      can :manage, AdminUser, id: user.id
    elsif user.author?
      can :manage, Slickr::Page
      cannot :publish, Slickr::Page
      cannot :unpublish, Slickr::Page
      can :manage, ActiveAdmin::Comment
    end

    # NOTE: Everyone can read the page of Permission Deny
    can :read, ActiveAdmin::Page, name: "Dashboard"
  end
end
