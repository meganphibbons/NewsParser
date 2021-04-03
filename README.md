# TwitterParser

## Language Choice and Reasonsing:
### General Project Idea
We chose to use OCaml for our final project because we thought that the idea of parsing would be really interesting and tricky to navigate. Additionally, we thought that it would be beneficial to compare how OCaml parsing works in comparison to something like Scheme, where we used features of the language to parse the language itself. 

### Strenghts of OCaml
- For one, OCaml has a lot of parsing functionality and is well-known for the ease in which you can parse
- OCaml is so good at parsing due to its exhaustivity checking and strong typing
- Additionally, OCaml allows the use of pattern-matching in function definitions, meaning we can check for matches in a function definition easily. 
- Lastly, OCaml is very efficient in its implementation, making it a good language for a project that requires parsing a lot of data. 

### Weaknesses of OCaml
- In terms of the Twitter network calls, the code may not actually be efficient, because OCaml is not thread safe and the threads do not run in parallel.  
    - That being said, upon doing some research, it seems that there are a few libraries that could be useful for making network calls that would improve performance and make this a bit easier. 
- More generally, it appears that the standard library is pretty limited, memory management isn't great, and sometimes there is unnecessary boxing of data types. 

## Project Sections and Point Values
### Part One - Data Fetching (20 points)
- The main purpose of this part of the project is to get RESTful API bindings up and running with OCaml. The focus will be to extract data through Twitter's API; specifically gathering tweets to be parsed by the next portion of this assignment. To help with network requests in OCaml, we will be using [Netblob](https://github.com/chrismamo1/ppx_netblob). 
- Here is the [reference index](https://developer.twitter.com/en/docs/twitter-api/api-reference-index) for the Twitter API. We will mostly focus on using the filtered stream endpoint. 
- In order to receive the tweet using Netblob, a JSON schema must be defined to hold the response. The netblob annotation attaches to a record type declaration which will then a function that can call the endpoint with a given set of parameters. The objective is to extract a single raw tweet (no metadata) and once that finishes this section. 
### Part Two - Parsing & Extracting Useful Data (20 points)
- The main purpose of this part of the project is to utilize OCaml's parsing abilities to parse and extract relevant information from the Twitter data. Essentially, given a certain hashtag or keyword, figure out all of the relevant data that is associated with that keyword. This requires some parsing of the Twitter data to actually access tweets themselves (and filter out miscellaneous data like dates, usernames, etc). Additionally, this requires filtering out unnecessary data, sometimes including things like numbers or non-keywords ("and" "or" "but").   
- After extracting the data itself, it is necessary to process the data and put it into a useful format. To do this, figure out which words show up the most across all tweets under a given Hashtag, ranking them based on importance (number of keywords, potentially number of likes that posts with those keywords get) and determine what the main ideas of the hashtag are. 
- Once you have an ordered list of relevant keywords, this section should be complete! Pass on these keywords to part 3 to generate some potential fake tweets. 
### Part Three - Generating Fake Tweets Using Data (20 points)
- The main purpose of this part of the project is to utilize the ordered list generated in part two to create reasonably realistic tweets that would logically align with the hashtag.  
- These sentences will take the form "adjective" + "noun" +  "verb phrase". The verb phrase will consist of either simply an intransitive verb or an transitive verb with another noun. The nouns and verbs and their classifications come from part two. 
- Once the tweet is constructed, this section is complete. Pass on the tweet to part 4 to be posted. 
### Part Four - Posting a Fake Tweet (5 points)

## Work Breakdown
### Everyone
- Work on README
- Communicate about changes/necessities for the project 
- Work on presentation together
- Finishing up part 4 (this may go to an individual depending on timelines and relative difficulties of each part)

### Dorian
- Primarily will work on Part 1, fetching data from Twitter using some network calls and the Twitter API

### Megan
- Primarily will work on Part 2, parsing the information from Dorian's network calls, filtering out unnecessary data, and sorting results based on relevance

### Annie
- Primarily will work on Part 3, using the data collected by Megan and general information from Dorian to generate fake tweets that could possibly (reasonably) show up in the hashtag. 