# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
  def update?
    user.has_role? :admin
  end

  def new?
    user.has_role? :admin
  end

  def create?
    user.has_role? :admin
  end
end
