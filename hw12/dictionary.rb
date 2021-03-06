require 'test/unit'

# Design a class to represent a dictionary
class Dictionary
  
# We know that the dictionary starts out empty
  def initialize
    @dictionary = {}
  end

# Don't know yet how I will represent info
  def empty?
    @dictionary.empty?
  end
  
  def add_translation(english, foreign, lang = "french")
    data = {:word => english, :lang => lang}
    @dictionary[foreign] = data
  end
  
  def translate(foreign)
    @dictionary[foreign][:word]
  end
  
  def lang(foreign)
    @dictionary[foreign][:lang]
  end

end

# Test the class as we develop it
class DictionaryTest < Test::Unit::TestCase
  
  def setup
    @dict = Dictionary.new
  end

# Check that a new dictionary is empty
  def test_empty_dict
    assert @dict.empty?
  end

# Check that once you add at least one translation it is not empty  
  def test_adding_xlate
    @dict.add_translation("book", "boek")
    assert !@dict.empty?
  end
  
# Check that I can fetch the translation I adde@dict.
  def test_add_fetch_xlate
    @dict.add_translation("book", "boek")
    book = @dict.translate("boek")
    assert_equal "book", book, "expected translation to be book"
  end
  
# Let's check two translations
  def test_add_two_xlates
    @dict.add_translation("book", "boek")
    @dict.add_translation("house", "huis")
    assert !@dict.empty?
    assert_equal "book", @dict.translate("boek")
    assert_equal "house", @dict.translate("huis")
  end  

# check that you can specify a language 
  def test_add_words_in_different_languages
    @dict.add_translation("book", "bork", "swahili")
    assert_equal "book", @dict.translate("bork")
    assert_equal "swahili", @dict.lang("bork")
  end
  
end
