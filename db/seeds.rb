# ruby encoding: utf-8
require 'json'

character_classes = [
  "barbarian",
  "bard",
  "cleric",
  "druid",
  "fighter",
  "monk",
  "paladin",
  "ranger",
  "rogue",
  "sorcerer",
  "warlock",
  "wizard"
]

subclasses = [
  "lore",
  "land",
  "devotion",
  "life",
  "fiend"
]

components = [
  {
    name: "Verbal",
    abbreviation: "V",
    description: "A verbal component is a spoken incantation. To provide a verbal component, you must be able to speak in a strong voice. A silence spell or a gag spoils the incantation (and thus the spell). A spellcaster who has been deafened has a 20% chance to spoil any spell with a verbal component that he or she tries to cast."
  },
  {
    name: "Somatic",
    abbreviation: "S",
    description: "A somatic component is a measured and precise movement of the hand. You must have at least one hand free to provide a somatic component."
  },
  {
    name: "Material",
    abbreviation: "M",
    description: "A material component is one or more physical substances or objects that are annihilated by the spell energies in the casting process. Unless a cost is given for a material component, the cost is negligible. Don’t bother to keep track of material components with negligible cost. Assume you have all you need as long as you have your spell component pouch."
  },
  {
    name: "Focus",
    abbreviation: "F",
    description: "A focus component is a prop of some sort. Unlike a material component, a focus is not consumed when the spell is cast and can be reused. As with material components, the cost for a focus is negligible unless a price is given. Assume that focus components of negligible cost are in your spell component pouch."
  },
  {
    name: "Divine Focus",
    abbreviation: "DF",
    description: "A divine focus component is an item of spiritual significance. The divine focus for a cleric or a paladin is a holy symbol appropriate to the character’s faith. If the Components line includes F/DF or M/DF, the arcane version of the spell has a focus component or a material component (the abbreviation before the slash) and the divine version has a divine focus component (the abbreviation after the slash)."
  },
  {
    name: "XP Cost",
    abbreviation: "XP",
    description: "Some powerful spells entail an experience point cost to you. No spell can restore the XP lost in this manner. You cannot spend so much XP that you lose a level, so you cannot cast the spell unless you have enough XP to spare. However, you may, on gaining enough XP to attain a new level, use those XP for casting a spell rather than keeping them and advancing a level. The XP are treated just like a material component—expended when you cast the spell, whether or not the casting succeeds."
  }
]

schools = [
  {
    name: "Evocation",
    url: "http://www.dnd5eapi.co/api/magic-schools/5"
  },
  {
    name: "Conjuration",
    url: "http://www.dnd5eapi.co/api/magic-schools/2"
  },
  {
    name: "Abjuration",
    url: "http://www.dnd5eapi.co/api/magic-schools/1"
  },
  {
    name: "Transmutation",
    url: "http://www.dnd5eapi.co/api/magic-schools/8"
  },
  {
    name: "Enchantment",
    url: "http://www.dnd5eapi.co/api/magic-schools/4"
  },
  {
    name: "Necromancy",
    url: "http://www.dnd5eapi.co/api/magic-schools/7"
  },
  {
    name: "Divination",
    url: "http://www.dnd5eapi.co/api/magic-schools/3"
  },
  {
    name: "Illusion",
    url: "http://www.dnd5eapi.co/api/magic-schools/6"
  }
]

character_classes.each do |name|
  CharacterClass.find_or_create_by(name: name)
end

subclasses.each do |name|
  Subclass.find_or_create_by(name: name)
end

schools.each do |school|
  puts school
  School.find_or_create_by(name: school[:name], url: school[:url])
end

components.each do |component|
  Component.find_or_create_by(
    name: component[:name],
    abbreviation: component[:abbreviation],
    description: component[:description]
  )
end

file = File.read("database-master/5e-SRD-Spells.json")
data = JSON.parse(file)

name = nil
description = nil
higher_level = nil
page = nil
range = nil
components = []
school = nil
ritual = false
concentration = false
cast_time = nil
duration = nil
materials = nil
level = nil

data.each do |spell|
  name = spell["name"]
  description = spell["desc"]
  if spell.key?("higher_level")
    higher_level = spell["higher_level"][0]
  end
  page = spell["page"][4..-1]
  case spell["range"]
  when "Self"
    range = 0
    range_unit = "Self"
  when "Touch"
    range = 0
    range_unit = "Touch"
  when "Special"
    range = 0
    range_unit = "Special"
  when "Sight"
    range = 0
    range_unit = "Sight"
  when "Unlimited"
    range = 0
    range_unit = "Unlimited"
  else
    range = spell['range'].partition(" ").first.to_i
    range_unit = spell['range'].partition(" ").last
  end

  if spell["ritual"] == "no"
    ritual = false
  elsif spell["ritual"] == "yes"
    ritual = true
  end

  if spell["concentration"] == "no"
    concentration = false
  elsif spell["concentration"] == "yes"
    concentration = true
  end

  cast_time = spell["cast_time"]
  duration = spell["duration"]
  materials = spell["materials"]
  level = spell["level"].to_i

  new_spell = Spell.find_or_create_by(
    name: name,
    description: description.join("\n")
      .gsub("â€œ", "\"")
      .gsub("â€", "\"")
      .gsub("â€�", "\"")
      .gsub("â€˜", "'")
      .gsub("â€™", "'")
      .gsub("â€”", "-")
      .gsub("â€“", "-")
      .gsub("â€¢", "-")
      .gsub("â€¦", "..."),
    higher_level: higher_level,
    page: page,
    range: range,
    range_unit: range_unit,
    ritual: ritual,
    concentration: concentration,
    cast_time: cast_time,
    duration: duration,
    materials: materials,
    level: level
  )

  spell["components"].each do |component|
    new_spell.components << Component.find_by(abbreviation: component)
  end

  spell["classes"].each do |class_name|
    new_spell.character_classes << CharacterClass.find_by(name: class_name["name"])
  end

  spell["subclasses"].each do |subclass|
    new_spell.subclasses << Subclass.find_by(name: subclass["name"])
  end

  new_spell.school = School.find_by(name: spell["school"]["name"])

  new_spell.save!

end