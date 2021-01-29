# https://www.nytimes.com/puzzles/spelling-bee
# usage:
#     SpellingBeeSolver.new.solve("t", ["h", "i", "s"])
#     SpellingBeeSolver.new.solve_pangram("t", ["h", "i", "s"])
#     SpellingBeeSolver.new.solve_fixed_length("t", ["h", "i", "s"], 4)
######################################################################

require "ffi/aspell"
require_relative "./configs_reader"

class SpellingBeeSolver
  DEFAULT_WORD_MAX_COUNT = 6
  DEFAULT_WORD_MAX_LENGTH = 8

  def initialize
    @speller = FFI::Aspell::Speller.new('en_US')
    begin
      reader = ConfigsReader.new
      @word_max_count = reader.get_word_max_count
      @word_max_length = reader.get_word_max_length
    rescue
      puts "read configs error: #{$!}"
      puts "use default configs"
      @word_max_count = DEFAULT_WORD_MAX_COUNT
      @word_max_length = DEFAULT_WORD_MAX_LENGTH
    end
  end

  def check_spell(word)
    @speller.correct? word
  end

  def arrange(letters)
    arrangements = []
    table = Hash.new 
    letters.each do |letter|
      if table.has_key? letter
        table[letter] += 1
      else
        table[letter] = 1
      end
    end
    arrange_backtrack([], arrangements, table, 0, letters.size)    
    return arrangements
  end

  def combine(letters, n)
    combinations = []
    combine_backtrack([], combinations, letters, 0, n)
    return combinations
  end

  def solve_fixed_length(core, others, len)
    words = []
    letters = others + [core]
    combine(letters, len-1).each do |combination|
      words_of_combination = arrange(combination.append(core)).filter! { |word|
        check_spell word
      }
      words.concat words_of_combination
    end
    return words[0, @word_max_count]
  end

  def solve_pangram(core, others)
    letters = others + [core]
    arrange(letters).filter! { |word|
      check_spell word
    }
  end
  
  def solve(core, others)
    words = []
    (4...@word_max_length).each do |n|
      words.concat solve_fixed_length(core, others, n)
    end
    return words
  end

  private
  def combine_backtrack(combines, combinations, letters, index, n)
    if combines.size == n 
      combinations << combines.sort
      return
    end

    for i in index..letters.size-1 do
      letter = letters[i]
      combines.push letter
      combine_backtrack(combines, combinations, letters, i, n)
      combines.pop
    end
  end

  def arrange_backtrack(combines, arrangements, table, size, n)
    if size == n
      arrangements << combines.join 
      return
    end
      
    table.keys.each do |candidate|
      next if table[candidate] == 0
      combines.push candidate
      table[candidate] -= 1
      arrange_backtrack combines, arrangements, table, size + 1, n
      combines.pop 
      table[candidate] += 1
    end
  end
end

