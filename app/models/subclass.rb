class Subclass < ActiveRecord::Base
  has_many :subclasses_spells
  has_many :spells, through: :subclasses_spells
end