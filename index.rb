require_relative "spelling_bee_solver"
require "set"
require "tty-prompt"

prompt = TTY::Prompt.new()

puts "You can find a puzzle here: https://www.nytimes.com/puzzles/spelling-bee"
puts "---\n"

# get arguments
# --------------------------------
selections = {
  "[1] pangram solver(default)": 1,
  "[2] fixed length solver": 2,
  "[3] all length solver": 3}
solver_num = prompt.select("Choose a solver:", selections, cycle: true)

core = prompt.ask("Core letter:") do |q|
  q.required true
  q.validate /\A[a-zA-Z]\Z/, "Core letter is only a english letter: a~z or A~Z"
  q.modify :remove, :down
end

others = prompt.ask("Other letters:") do |q|
  q.required true
  q.validate /\A[a-zA-Z]{3,}\Z/, "Other letters are at least 3 english letters: a~z or A~Z"
  q.modify :remove, :down
end
others = others.chars.to_set.delete(core).to_a
print "Other letters are trimed to: "
prompt.ok(others.join)

prompt.say "...\n...\n..."
prompt.say("If you have wait for too much time, you can enter [ctrl-C] to quit; and then choose a smaller WORD_MAX_LENGTH to retry", color: [:cyan, :dim])
prompt.say "...\n...\n..."
result = nil

# solve
# --------------------------------
solver = SpellingBeeSolver.new
case solver_num
when 2
  begin
    print "word length:[2~20] "
    word_len = gets.chomp.to_i
  end until (2..20).include?(word_len)
  result = solver.solve_fixed_length(core, others, word_len)
when 1
  result = solver.solve_pangram(core, others)
when 3
  result = solver.solve(core, others)
else
  prompt.error "error with solver[#{solver_num}]"
end

# print result
# --------------------------------
if not result.nil?
  if result.size > 0
    prompt.say("solved words are:") 
    result.each { |word| prompt.ok(word) }
  else
    prompt.warn("no word found")
  end
end
