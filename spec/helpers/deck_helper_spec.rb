require 'spec_helper'

describe DeckHelper do
  describe 'is_pronunciation_on_front?' do

  end

  describe 'is_pronunciation_on_back?' do

  end

  describe 'deck_subtitle' do

  end

  describe 'string_in_array' do
    it 'should return false is string is empty' do
      string_in_array("", ['a', 'b']).should == false
    end

    it 'should return false is array is empty' do
      string_in_array("a", []).should == false
    end

    it 'should return true if string is in array' do
      string_in_array("asdf", ['a', 'asdfd', 'asdf', 'b']).should == true
    end

    it 'should return false if string is not in array' do
      string_in_array("c", ['a', 'b']).should == false
    end
  end

  describe 'get_word_length' do
    it 'should return 0 for empty string' do
      get_word_length("").should == 0
    end

    it 'should condier single byte chars' do
      get_word_length("a").should == 1
    end

    it 'should consider multi byte chars' do
      get_word_length("ā").should == 1
    end

    it 'should consider mixed byte strings' do
      get_word_length("āa").should == 2
    end
  end

  describe 'get_char_size_in_bytes' do
    it 'should return 0 for empty string' do
      get_size_in_bytes("").should == 0
    end

    it 'should condier single byte chars' do
      get_size_in_bytes("a").should == 1
    end

    it 'should consider multi byte chars' do
      get_size_in_bytes("ā").should == 2
    end

    it 'should consider mixed byte strings' do
      get_size_in_bytes("āa").should == 3
    end
  end

  describe 'multibyte_to_array' do
    it 'should turn string into a multibyte array' do
      multibyte_to_array("āaā").should == ["ā", "a", "ā"]
    end
  end

  describe 'is_first_character' do
    it 'should return false if index is not 0' do
      is_first_character(1).should == false
    end

    it 'should return true if index is 0' do
      is_first_character(0).should == true
    end
  end

  describe 'is_last_character' do
    it 'should return false if not last char' do
      is_last_character(0, "word").should == false
      is_last_character(1, "word").should == false
      is_last_character(2, "word").should == false
      is_last_character(3, "word").should == true
    end

    it 'should return true if index is last char' do
      is_last_character(0, "w").should == true
      is_last_character(3, "word").should == true
    end
  end

  describe 'get_char' do
    it 'should return char at index' do
      get_char("dsfa", 0).should == 'd'
      get_char("dsfa", 1).should == 's'
      get_char("dsfa", 2).should == 'f'
      get_char("dsfa", 3).should == 'a'

      get_char("āsfa", 0).should == 'ā'
      get_char("dāfa", 0).should == 'd'
      get_char("dāfa", 1).should == 'ā'
      get_char("dāfa", 2).should == 'f'

      get_char("dāfa", -1).should == 'a'
    end
  end

  describe 'get_pronunciation_expansion' do
    it 'it should each character without expansion if no expansion exists' do
      get_pronunciation_expansion("1234").should == "1, 2, 3, 4"
    end

    it 'should match the longest matchers first' do
      get_pronunciation_expansion("b").should == "<em>b</em>oy"
      get_pronunciation_expansion("ng").should == "so<em>ng</em>"
      get_pronunciation_expansion("ngb").should == "so<em>ng</em>, <em>b</em>oy"
      get_pronunciation_expansion("nngb").should == "<em>n</em>imble, so<em>ng</em>, <em>b</em>oy"
    end

    it 'should handle the a character with accents' do
      get_pronunciation_expansion("ā").should == "m<em>a</em>"
      get_pronunciation_expansion("é").should == "<em>e</em>arn"
      get_pronunciation_expansion("í").should == "s<em>i</em>t"
      get_pronunciation_expansion("ò").should == "dr<em>o</em>p"
      get_pronunciation_expansion("ū").should == "l<em>oo</em>k"
    end

    it 'should handle combined vowels with accents' do
      get_pronunciation_expansion("ai").should == "<em>eye</em>"
      get_pronunciation_expansion("āi").should == "<em>eye</em>"
      get_pronunciation_expansion("aí").should == "<em>eye</em>"
      get_pronunciation_expansion("āí").should == "<em>eye</em>"
      get_pronunciation_expansion("üe").should == "<em>we</em>t"
      get_pronunciation_expansion("íao").should == "m<em>eow</em>"
      get_pronunciation_expansion("iāo").should == "m<em>eow</em>"
      get_pronunciation_expansion("iaò").should == "m<em>eow</em>"
      get_pronunciation_expansion("íāò").should == "m<em>eow</em>"
    end

    it 'should handle a forward and back checks' do
      get_pronunciation_expansion("iā").should == "<em>ea</em>r"
      get_pronunciation_expansion("iās").should == "<em>ea</em>r, <em>s</em>on"
      get_pronunciation_expansion("ān").should == "m<em>a</em>, <em>n</em>imble"
      get_pronunciation_expansion("jān").should == "<em>j</em>eep, m<em>a</em>, <em>n</em>imble"
      get_pronunciation_expansion("iān").should == "<em>ea</em>r, <em>n</em>imble"


      get_pronunciation_expansion("én").should == "<em>e</em>arn, <em>n</em>imble"
      get_pronunciation_expansion("né").should == "<em>n</em>imble, <em>e</em>arn"
      get_pronunciation_expansion("ié").should == "<em>air</em>"
      get_pronunciation_expansion("ué").should == "l<em>oo</em>k, g<em>e</em>t"

      get_pronunciation_expansion("zhi").should == "slu<em>dg</em>e, vocalised <em>r</em>"
      get_pronunciation_expansion("zwi").should == "wor<em>ds</em>, <em>w</em>e, s<em>i</em>t"
      get_pronunciation_expansion("chi").should == "<em>ch</em>ildren, vocalised <em>r</em>"
      get_pronunciation_expansion("cwi").should == "ea<em>ts</em>, <em>w</em>e, s<em>i</em>t"
      get_pronunciation_expansion("shi").should == "<em>sh</em>ake, vocalised <em>r</em>"
      get_pronunciation_expansion("swi").should == "<em>s</em>on, <em>w</em>e, s<em>i</em>t"
      get_pronunciation_expansion("ri").should == "<em>r</em>aw, vocalised <em>r</em>"
      get_pronunciation_expansion("di").should == "<em>d</em>ig, s<em>i</em>t"
      get_pronunciation_expansion("hi").should == "<em>h</em>ot, s<em>i</em>t"

      get_pronunciation_expansion("zi").should == "wor<em>ds</em>, <em>i</em> like a buzzing bee"
      get_pronunciation_expansion("ci").should == "ea<em>ts</em>, <em>i</em> like a buzzing bee"
      get_pronunciation_expansion("si").should == "<em>s</em>on, <em>i</em> like a buzzing bee"

      get_pronunciation_expansion("on").should == "dr<em>o</em>p, <em>n</em>imble"
      get_pronunciation_expansion("ohg").should == "dr<em>o</em>p, <em>h</em>ot, <em>g</em>ood"
      get_pronunciation_expansion("ong").should == "s<em>o</em>w, so<em>ng</em>"
    end
  end
end
