class Ingredient < ApplicationRecord
  has_many :doses # , dependent: :restrict_with_exception
  has_many :cocktails, through: :doses
  validates :name, presence: true, uniqueness: true
end
