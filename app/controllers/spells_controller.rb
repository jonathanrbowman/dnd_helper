class SpellsController < ApplicationController
  def index
    if params[:search_text].present?
      @spells = Spell.search(params[:search_text], order: :name, where: {})
      # @spells = Spell.search(params[:search_text], order: :name, where: {character_classes: "wizard"})
    end
  end

  def search
    @spells = Spell.search(params[:search_text], order: :name, where: {})
    render partial: "spells/results", locals: {
      spells: @spells
    }
  end

  def show
    @spell = Spell.find(params[:id])
  end
end