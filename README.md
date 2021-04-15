# TwitterParser

## Language Choice and Reasonsing:
### General Project Idea
We chose to use OCaml for our final project because we thought that the idea of parsing would be really interesting and tricky to navigate. Additionally, we thought that it would be beneficial to compare how OCaml parsing works in comparison to something like Scheme, where we used features of the language to parse the language itself. 

### Strengths of OCaml
- For one, OCaml is well-known for the ease in which you can parse
- OCaml is so good at parsing in part due to its exhaustivity checking (making sure all cases are covered)
- Additionally, OCaml allows the use of pattern-matching in function definitions, which will help with writing parse functions
- Lastly, OCaml is a compiled language with a very efficient implementation, making it a good language for a project that requires parsing through a lot of data. 

### Weaknesses of OCaml
- In terms of the Twitter network calls, the code may not actually be efficient, because OCaml is not inherently thread safe and the threads do not run in parallel.  
    - That being said, upon doing some research, it seems that there are a few libraries that could be useful for making network calls that would improve performance and make this a bit easier. 
- More generally, it appears that the standard library is pretty limited, memory management isn't great, and sometimes there is unnecessary boxing of data types. 

## Project Sections and Point Values
### Part One - Data Fetching (20 points)
- **Modified due to delay in access to Twitter's API**
- An alternative API to access is the (free) Hackernews API. Hackernews works similar to Reddit in the sense that there are posts and comments which file under posts or other comments. This creates a tree like structure with the root as the original post. 
- The details of the Hackernews API is listed here: [Hackernews API](https://github.com/HackerNews/API). The end point we will focus on is accessing items using a particular ID. In fact, regardless of item type (post, comment, poll, etc), they all use the same endpoint with the only differentiating parameter being the unique item ID. 
- The first step is to set up the HTTP request using a random ID (the API provides the max ID) with the cohttp library and parse with yojson. 
- The second step is to consider whether the item is a post or a comment. In the case of a comment, use the fields provided in the response body to traverse the comment tree back to the root post. Once there, traverse the entire comment tree extracting the comments into a list which can then be passed to Part Two. 
### Part Two - Parsing & Extracting Useful Data (20 points)
- The main purpose of this part of the project is to utilize OCaml's parsing abilities to parse and extract relevant information from the Twitter data. Essentially, given a certain hashtag or keyword, figure out all of the relevant data that is associated with that keyword. This requires some parsing of the Twitter data to actually access tweets themselves (and filter out miscellaneous data like dates, usernames, etc). Additionally, this requires filtering out unnecessary data, sometimes including things like numbers or non-keywords ("and" "or" "but").   
- After extracting the data itself, it is necessary to process the data and put it into a useful format. To do this, figure out which words show up the most across all tweets under a given Hashtag, ranking them based on importance (number of keywords, potentially number of likes that posts with those keywords get) and determine what the main ideas of the hashtag are. 
- Once you have an ordered list of relevant keywords, this section should be complete! Pass on these keywords to part 3 to generate some potential fake tweets. 
### Part Three - Generating Fake Tweets Using Data (20 points)
- The main purpose of this part of the project is to visualize the data from Part 2.  
- Given the tree generated from part 2, the tree will be converted to dot language, which can be visuzlied with the GraphViz library. 
- Once the tree is visualized, this section is complete. 
### Part Four - Posting a Fake Tweet (5 points)
- Hopefully the work done in Part One should make this section relatively straight forward. The objective is to take the newly constructured tweet from Part Three and actually post the tweet to Twitter. 
- Again here is the [Twitter API](https://developer.twitter.com/en/docs/twitter-api/api-reference-index), the important compenent will be the POST statuses update endpoint. 

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