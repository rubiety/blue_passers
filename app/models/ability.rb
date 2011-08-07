class Ability
  include CanCan::Ability

  def initialize(current_user)
    can :manage, :all
  end
end
