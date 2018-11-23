class AddSpells < ActiveRecord::Migration[5.2]
  def change
    create_table :spells do |t|
      t.string :name, null: false
      t.text :description
      t.text :higher_level
      t.string :page
      t.integer :level
      t.integer :range
      t.string :range_unit
      t.boolean :ritual, default: false
      t.boolean :concentration, default: false
      t.string :cast_time
      t.string :duration
      t.text :materials
      t.integer :school_id

      t.timestamps
    end

    create_table :components do |t|
      t.string :name, null: false
      t.string :abbreviation
      t.text :description
      t.timestamps
    end

    create_table :spell_components do |t|
      t.integer :spell_id
      t.integer :component_id
    end

    create_table :schools do |t|
      t.string :name, null: false
      t.string :url
      t.timestamps
    end

    create_table :character_classes do |t|
      t.string :name, null: false
      t.string :url
      t.timestamps
    end

    create_table :character_classes_spells do |t|
      t.integer :character_class_id
      t.integer :spell_id
      t.timestamps
    end

    create_table :subclasses do |t|
      t.string :name, null: false
      t.string :url
      t.timestamps
    end

    create_table :subclasses_spells do |t|
      t.integer :subclass_id
      t.integer :spell_id
      t.timestamps
    end

    add_index(:spell_components, [:spell_id, :component_id], unique: true, name: 'index_on_spell_components')
    add_index(:character_classes_spells, [:character_class_id, :spell_id], unique: true, name: 'index_on_character_classes_spells')
    add_index(:subclasses_spells, [:subclass_id, :spell_id], unique: true, name: 'index_on_subclasses_spells')
  end
end
