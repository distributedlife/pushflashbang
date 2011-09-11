# Migrate Decks
# ACCS - Twers (reading practice)
#name = "ACCS - Twers (reading practice)"
#deck = Deck.where(:name => name).first
#set = Sets.create
#SetName.create(:name => deck.name, :description => deck.description, :sets_id => set.id)
#set.migrate_from_deck deck.id

# ACCS - Level 2 -TW (reading practice)
#name = "ACCS - Level 2 -TW (reading practice)"
#deck = Deck.where(:name => name).first
#set = Sets.create
#SetName.create(:name => deck.name, :description => deck.description, :sets_id => set.id)
#set.migrate_from_deck deck.id

# Conversational Chinese 301
#name = "Conversational Chinese 301"
deck = Deck.find(15)
set = Sets.create
SetName.create(:name => deck.name, :description => deck.description, :sets_id => set.id)
set.migrate_from_deck deck.id

#Migrate all users to learning Chinese (Simplified)
chinese = Language::get_or_create "Chinese (Simplified)"
User.all.each do |user|
  if UserLanguages.where(:user_id => user.id, :language_id => chinese.id).empty?
    UserLanguages.create(:user_id => user.id, :language_id => chinese.id)
  end
end
