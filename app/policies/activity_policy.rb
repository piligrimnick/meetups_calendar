class ActivityPolicy < ApplicationPolicy
  def change?
    record.user_id == user.id
  end

  alias_method :edit?, :change?
  alias_method :update?, :change?
  alias_method :destroy?, :change?
end
