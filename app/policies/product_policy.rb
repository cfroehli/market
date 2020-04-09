class ProductPolicy < ApplicationPolicy
  def update?
    @user.has_role? :admin
  end

  def create?
    @user.has_role? :admin
  end
end
