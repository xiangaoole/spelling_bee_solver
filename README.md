# Spelling Bee Solver

Spelling Bee is a word puzzle, like [the game in The New York Times](https://www.nytimes.com/puzzles/spelling-bee).

![demo](demo.gif)

> ### How to Play
>
> #### Create words using letters from the hive.
>
> - Words must contain at least 4 letters.
> - Words must include the center letter.
> - Our word list does not include words that are obscure, hyphenated, or proper nouns.
> - No cussing either, sorry.
> - Letters can be used more than once.
>
> #### Score points to increase your rating.
>
> - 4-letter words are worth 1 point each.
> - Longer words earn 1 point per letter.
> - Each puzzle includes at least one “pangram” which uses every letter. These are worth 7 extra points!



## Play

Requirement:

1. GNU `aspell` installed: `brew install aspell`
2. `ruby` installed: `brew install ruby`
3. ruby gem `ffi-aspell` installed: `gem install ffi-aspell`



To run this ruby in CLI:

```bash
rake
```



## Explanation

This solver works in 4 steps:

1. get the center letter and other letters
2. **combine**: choose n-1 letters from all letters(letters may be used more than once but each combination is unique)
3. **arrange**: arrange the order of the center letter and the other n-1 combined letters(each arrangement is unique)
4. **spell check**: check the spells of the each arranged word



Several solvers are provide:

- **pangram solver**: give the "pangram" words
- **fixed length solver**: give the fixed length words
- **solver**: give all the words



The default word count of "pangram solver" and "fixed length solver" is set by `WORD_MAX_COUNT`. The "solver" will give all the words while word's length limited to be under `WORD_MAX_LENGTH` and word count of each length is limited to be under `WORD_MAX_COUNT`.

You can set these constants in `configs.yml`
