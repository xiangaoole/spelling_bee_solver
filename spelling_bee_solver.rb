# https://www.nytimes.com/puzzles/spelling-bee
# usage:
#
#

require "ffi/aspell"

class SpellingBeeSolver
  def initialize
    @speller = FFI::Aspell::Speller.new('en_US')
  end

  def check_spell(word)
    @speller.correct? word
  end

  def arrange(letters)
    results = []
    table = Hash.new 
    letters.each do |letter|
      if table.has_key? letter
        table[letter] += 1
      else
        table[letter] = 1
      end
    end
    arrange_backtrack([], results, table, 0, letters.size)    
    return results
  end

  def combine(letters, n)
    results = []
    combine_backtrack([], results, letters, 0, n)
    return results
  end

  def solve_fixed_length(core, others, len)
    results = []
    letters = others + [core]
    combine(letters, len).each do |letters|
      results.concat(arrange(letters.append(core)).filter! { |word| check_spell(word) })
    end
    return results
  end

  def solve_bravo(core, others)
    letters = others + [core]
    arrange(letters)
  end
  
  def solve(core, others, max=6)
    results = []
    (3...max).each do |n|
      results.concat solve_fixed_length(core, others, n)
    end
    return results
  end

  private
  def combine_backtrack(combines, results, letters, index, n)
    if combines.size == n 
      results << combines.sort
      return
    end

    for i in index..letters.size-1 do
      letter = letters[i]
      combines.push letter
      combine_backtrack(combines, results, letters, i, n)
      combines.pop
    end
  end

  def arrange_backtrack(combines, results, table, size, n)
    if size == n
      results << combines.join
      return
    end
      
    table.keys.each do |candidate|
      next if table[candidate] == 0
      combines.push candidate
      table[candidate] -= 1
      arrange_backtrack combines, results, table, size + 1, n
      combines.pop 
      table[candidate] += 1
    end
  end
end

