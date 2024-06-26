# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.librarian?
      can :manage, :all
    elsif user.member?
      can :read, Book
      can :search, Book
      can :create, BookBorrow
    end
  end
end
