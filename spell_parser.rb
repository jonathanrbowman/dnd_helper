# ruby encoding: utf-8
require 'json'

file = File.read("database-master/5e-SRD-Spells.json")
data = JSON.parse(file)
types = []

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
    description: description,
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
    new_spell.classes << CharacterClass.find_by(name: class_name)
  end

  spell["subclasses"].each do |subclass|
    new_spell.subclasses << Subclass.find_by(name: subclass)
  end

  new_spell.school = School.find_by(name: spell["name"]) 

  new_spell.save!

end