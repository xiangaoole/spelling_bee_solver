require_relative "spelling_bee_solver"
require "set"

puts "You can find a puzzle here: https://www.nytimes.com/puzzles/spelling-bee"
puts <<DOC
Choose a solver:
[1] pangram solver(default)
[2] fixed length solver
[3] all length solver
DOC
begin
  print "\n[1~3]: "
  input = gets.chomp
  if input == "" 
    solver_num = 1
  else
    solver_num = input.to_i
  end
end until (1..3).include?(solver_num)
puts "solver[#{solver_num}]"

begin
  print "core letter:(e.g. =>a) "
  core = gets.chomp.downcase.gsub(/[^a-z]/, "")[0]
end while core.nil?
puts "core letter is \"#{core}\""
  
begin
  print "other letters:(e.g. =>bcde) "
  others = gets.chomp.downcase.gsub(/#{core}|[^a-z]/, "")
end while others.empty?
others = others.chars.to_set.to_a
puts "other letters are \"#{others.join}\""

solver = SpellingBeeSolver.new
puts "solved words are:"
puts "If you have wait for too much time, you can enter [ctrl-C] to quit; and then choose a smaller WORD_MAX_LENGTH to retry"
case solver_num
when 2
  begin
    print "word length:[2~20] "
    word_len = gets.chomp.to_i
  end until (2..20).include?(word_len)
  puts solver.solve_fixed_length(core, others, word_len)
when 1
  puts solver.solve_pangram(core, others)
when 3
  puts solver.solve(core, others)
else
  puts "error with solver[#{solver_num}]"
end


