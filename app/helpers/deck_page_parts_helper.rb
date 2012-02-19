module DeckPagePartsHelper
  def list_decks decks
    render :partial => '/deck/user_decks', :locals => {:decks => decks}
  end
end