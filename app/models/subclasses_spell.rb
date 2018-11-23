class SubclassesSpell < ActiveRecord::Base
  belongs_to :subclass
  belongs_to :spell
end