class SpellComponent < ActiveRecord::Base
  belongs_to :spell
  belongs_to :component
end