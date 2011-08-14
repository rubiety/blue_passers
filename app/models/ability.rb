class Ability
  include CanCan::Ability

  def initialize(current_user)
    if current_user
      can :manage, User, :id => current_user.id
    end
  end
end
