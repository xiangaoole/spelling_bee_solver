# https://www.nytimes.com/puzzles/spelling-bee
# usage:
#
#

require "ffi/aspell"

class SpellingBeeSolver
  DEFAULT_WORD_MAX_COUNT = 10
  DEFAULT_WORD_MAX_LENGTH = 6

  def initialize
    @speller = FFI::Aspell::Speller.new('en_US')
    @word_max_count = DEFAULT_WORD_MAX_COUNT
    @word_max_length = DEFAULT_WORD_MAX_LENGTH
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
        check_spell(word)
      }

      words.concat words_of_combination
    end
    return words
  end

  def solve_pangram(core, others)
    letters = others + [core]
    arrange(letters).filter! do |word|
      check_spell word
    end
  end
  
  def solve(core, others)
    words = []
    (3...@word_max_length).each do |n|
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

