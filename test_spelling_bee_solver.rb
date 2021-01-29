require_relative 'spelling_bee_solver'
require 'test/unit'

class TestSpellingBee < Test::Unit::TestCase
  def setup
    @solver = SpellingBeeSolver.new
  end

  def test_check_spell
    assert_equal true, @solver.check_spell("foo")
    assert_equal false, @solver.check_spell("thiz")
  end
  
  def test_arrange
    assert_equal ["a"], @solver.arrange(["a"])
    assert_equal ["ab", "ba"].sort, @solver.arrange(["a", "b"]).sort
    assert_equal ["aab", "aba", "baa"].sort, @solver.arrange(["a", "a", "b"]).sort
    assert_equal ["aabb", "abab", "baab", "bbaa", "baba", "abba"].sort,
      @solver.arrange(["a","a","b","b"]).sort
  end
  
  def test_combine
    assert_equal [["a"], ["b"]].sort, @solver.combine(["a","b"], 1).sort
    expect = [["a","a"], ["b","b"], ["a","b"]]
    assert_equal expect.sort, @solver.combine(["a","b"], 2).sort
    expect = [["a","a","a"], ["a","a","b"], ["a","b","b"], ["b","b","b"]]
    assert_equal expect.sort, @solver.combine(["a","b"], 3).sort
  end

  def test_solve
    expect = ["hist", "hits", "shit", "this"]
    assert_equal expect.sort, @solver.solve_pangram("t", ["h","i","s"]).sort
    expect = ["hist", "hits", "shit", "sits", "this", "tits"] 
    assert_equal expect.sort, @solver.solve_fixed_length("t", ["h","i","s"], 4).sort
  end
end
