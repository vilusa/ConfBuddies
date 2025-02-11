# frozen_string_literal: true

# Rules governing permissions for Events
class EventPolicy < ApplicationPolicy
  # Everyone can view Event details
  def show?
    true
  end

  # Everyone can view Event details
  def index?
    true
  end

  # Logged in users can create Events
  def create?
    user.present?
  end

  # Only Admins can update Events
  def update?
    user&.admin?
  end

  # Only Admins can destroy Events
  def destroy?
    user&.admin?
  end

  # Rules governing a list of Events
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
