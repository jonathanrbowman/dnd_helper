class Spell < ActiveRecord::Base
  belongs_to :school
  has_many :character_classes_spells
  has_many :character_classes, through: :character_classes_spells
  has_many :subclasses_spells
  has_many :subclasses, through: :subclasses_spells
  has_many :spell_components
  has_many :components, through: :spell_components

  searchkick

  def search_data
    attributes.merge(
      character_classes: character_classes.map(&:name)
    )
  end
end