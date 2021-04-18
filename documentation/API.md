# NewsParser API

## General Workflow
- Dorian gets a random article using the HackerNews API
- Megan parses the json to see if it's a comment or article 
- Dorian traverses up until finding the original post
- Megan summarizes the data of the article and its children 
- Annie gets the summary and raw data and uses them to generate a visualization


## Data Fetching
- Input: random number (or nothing) Output: String: (json file contents in String format)

## Parsing 
- .isPost() or .isComment() Input: json file in String format Output: true/false
- .getRawContents() Input: json file in String format. Output: HTML file in String format
- .getKeywords() Input: String (HTML file) Output: List (common keywords for this data)
- .getParsedContents() Input: HTML file in String format. Output: raw data without any HTML text

## GraphViz Generation
- .makeGraphInput() Input: Raw data without HTML. Output: The input to make the graph with GraphViz
- .makeGraph() Input: graphViz input. Output: the actual graph created 