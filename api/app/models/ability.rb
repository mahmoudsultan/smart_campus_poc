# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
      if user.role == 'professor'
        can [:show_terms,:show_years, :show_lectures], Course, user_id: user.id
        can :show_roles, User, user_id: user.id
      elsif user.role == 'student'
        can [:show_terms,:show_years, :show_lectures], Course, user_id: user.id
        can :show_roles, User, user_id: user.id
      else
        can :read, :all
      end
  end

  def to_list
    rules.map do |rule|
      object = { actions: rule.actions, subject: rule.subjects.map{ |s| s.is_a?(Symbol) ? s : s.name } }
      object[:conditions] = rule.conditions unless rule.conditions.blank?
      object[:inverted] = true unless rule.base_behavior
      object
    end
  end
end
