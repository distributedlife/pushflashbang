module DeckHelper
  def deck_subtitle deck
    text = [] ;

    if deck.shared
      text = text + ["shared"] ;
    end

    if deck.supports_written_answer
      text = text +  ["typed"]
    end

    text = text + ["pn. on #{deck.pronunciation_side}"]


    "(#{text.join(', ')})"
  end
end
