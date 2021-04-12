# TwitterParser API

## General Workflow
- User inputs a hashtag to search
- Dorian somehow gets that data (from database or Twitter)
- Megan parses the json and just keep the tweet itself
- Megan summarizes the data of the tweet
- Annie gets the tweet summary and uses it for words that should potentially be included, then makes a phrase out of them 


## Data Fetching
- Input: String (hashtag) Output: String: (json file contents)

## Parsing 
- .getKeywords() Input: String (json file) Output: List (common keywords for this tweet)
- .getTweets() Input: String (json file) Output: List of tweets

## Tweet Generation 
- .makeMap() Input: List of Strings (tweets) output: the map itself Create the map of words to what follow them 
- Input: the map Output: the generated tweet Actually generate the tweet based on what follows them 

## Tweet Posting 
- Input: the tweet Output: "successful" 

## Timeline
- Create the slides file Sun Apr 11 
- Push the OCaml project structure by Apr 11 
- Lecture Materials done by Wednesday
    - Slides 
    - Live coding example
    - Resources to learn more
- Goal to have code done by the 20th
- Integration will happen between the 20th and 23rd

## Presentation Notes:
- Talk about Exhaustivity Checking (Annie) and pattern matching in function definitions (Megan)
- Use parsing as our real-world example 
- OCaml yacc (Dorian) as an example of a command that creates a parser from a grammar specification
- Live coding (all 3) 
