module DeckHelper
  def is_pronunciation_on_front? side
    return side == 'front'
  end

  def is_pronunciation_on_back? side
    return side == 'back'
  end

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
