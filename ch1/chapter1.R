# Import text data from CSV, no factors
tweets <- read.csv("https://assets.datacamp.com/production/repositories/19/datasets/27a2a8587eff17add54f4ba288e770e235ea3325/coffee.csv", stringsAsFactors = FALSE)

# View the structure of tweets
str(tweets)

# Isolate text from tweets
coffee_tweets <- tweets$text

## == Make the vector a VCorpus object (1)
# Recall that you've loaded your text data as a vector called coffee_tweets in the last exercise. Your next step is to convert this vector containing the text data to a corpus. As you've learned in the video, a corpus is a collection of documents, but it's also important to know that in the tm domain, R recognizes it as a data type.

# There are two kinds of the corpus data type, the permanent corpus, PCorpus, and the volatile corpus, VCorpus. In essence, the difference between the two has to do with how the collection of documents is stored on your computer. In this course, we will use the volatile corpus, which is held in your computer's RAM rather than saved to disk, just to be more memory efficient.

# To make a volatile corpus, R needs to interpret each element in our vector of text, coffee_tweets, as a document. And the tm package provides what are called Source functions to do just that! In this exercise, we'll use a Source function called VectorSource() because our text data is contained in a vector. The output of this function is called a Source object. Give it a shot!
# 
# Load tm
library(tm)

# Make a vector source from coffee_tweets
coffee_source <- VectorSource(coffee_tweets)

# Make a volatile corpus from coffee_corpus
coffee_corpus <- VCorpus(coffee_source)

# Print out coffee_corpus
coffee_corpus

# Print the 15th tweet in coffee_corpus
coffee_corpus[[15]]

# Print the contents of the 15th tweet in coffee_corpus
coffee_corpus[[15]][1]

# Now use content to review the plain text of the 10th tweet
content(coffee_corpus[[15]])

## == Make a VCorpus from a data frame
#If your text data is in a data frame, you can use DataframeSource() for your analysis. The data frame passed to DataframeSource() must have a specific structure:
  
#Column one must be called doc_id and contain a unique string for each row.
#Column two must be called text with "UTF-8" encoding (pretty standard).
#Any other columns, 3+, are considered metadata and will be retained as such.
#This exercise introduces meta() to extract the metadata associated with each document. Often your data will have metadata such as authors, dates, topic tags, or places that can inform your analysis. Once your text is a corpus, you can apply meta() to examine the additional document level information.

# Create a DataframeSource from the example text
df_source <- DataframeSource(example_text)

# Convert df_source to a volatile corpus
df_corpus <- VCorpus(df_source)

# Examine df_corpus
df_corpus

# Examine df_corpus metadata
meta(df_corpus)

# Compare the number of documents in the vector source
vec_corpus

# Compare metadata in the vector corpus
meta(vec_corpus)

## Cleaning with qdap
# The qdap package offers other text cleaning functions. Each is useful in its own way and is particularly powerful when combined with the others.

#bracketX(): Remove all text within brackets (e.g. "It's (so) cool" becomes "It's cool")
#replace_number(): Replace numbers with their word equivalents (e.g. "2" becomes "two")
#replace_abbreviation(): Replace abbreviations with their full text equivalents (e.g. "Sr" becomes "Senior")
#replace_contraction(): Convert contractions back to their base words (e.g. "shouldn't" becomes "should not")
#replace_symbol() Replace common symbols with their word equivalents (e.g. "$" becomes "dollar")

# Create the object: text
text <- "<b>She</b> woke up at       6 A.M. It\'s so early!  She was only 10% awake and began drinking coffee in front of her computer."

# Remove text within brackets
bracketX(text)

# Replace numbers with words
replace_number(text)

# Replace abbreviations
replace_abbreviation(text)

# Replace contractions
replace_contraction(text)

# Replace symbols with words
replace_symbol(text)

## All about stop words
# List standard English stop words
stopwords("en")

# Print text without standard stop words
removeWords(text, c(stopwords("en")))

# Add "coffee" and "bean" to the list: new_stops
new_stops <- c("coffee", "bean", stopwords("en"))

# Remove stop words from text
removeWords(text, new_stops)

## Intro to word stemming and stem completion
#Still, another useful preprocessing step involves word-stemming and stem completion. Word stemming reduces words to unify across documents. For example, the stem of "computational", "computers" and "computation" is "comput". But because "comput" isn't a real word, we want to reconstruct the words so that "computational", "computers", and "computation" all refer to a recognizable word, such as "computer". The reconstruction step is called stem completion.

# Create complicate
complicate <- c("complicated", "complication", "complicatedly")

# Perform word stemming: stem_doc
stem_doc <- stemDocument(complicate)

# Create the completion dictionary: comp_dict
comp_dict <- "complicate"

# Perform stem completion: complete_text 
complete_text <- stemCompletion(stem_doc, comp_dict)

# Print complete_text
complete_text

## == Word stemming and stem completion on a sentence
# Let's consider the following sentence as our document for this exercise:
# "In a complicated haste, Tom rushed to fix a new complication, too complicatedly."
# 
# This sentence contains the same three forms of the word "complicate" that we saw in the previous exercise. The difference here is that even if you called stemDocument() on this sentence, it would return the sentence without stemming any words. Take a moment and try it out in the console. Be sure to include the punctuation marks.

#This happens because stemDocument() treats the whole sentence as one word. In other words, our document is a character vector of length 1, instead of length n, where n is the number of words in the document. To solve this problem, we first remove the punctuation marks with the removePunctuation() function, you learned a few exercises back. We then strsplit() this character vector of length 1 to length n, unlist(), then proceed to stem and re-complete.

# Remove punctuation: rm_punc
rm_punc <- removePunctuation(text_data)

# Create character vector: n_char_vec
n_char_vec <- unlist(strsplit(rm_punc, split = " "))

# Perform word stemming: stem_doc
stem_doc <- stemDocument(n_char_vec)

# Print stem_doc
stem_doc

# Re-complete stemmed document: complete_doc
complete_doc <- stemCompletion(stem_doc, comp_dict)

# Print complete_doc
complete_doc

## == Apply preprocessing steps to a corpus
# The tm package provides a function tm_map() to apply cleaning functions to an entire corpus, making the cleaning steps easier.
# tm_map() takes two arguments, a corpus and a cleaning function. Here, removeNumbers() is from the tm package.
#corpus <- tm_map(corpus, removeNumbers)
#For compatibility, base R and qdap functions need to be wrapped in content_transformer().
#corpus <- tm_map(corpus, content_transformer(replace_abbreviation))
#You may be applying the same functions over multiple corpora; using a custom function like the one displayed in the editor will save you time (and lines of code). clean_corpus() takes one argument, corpus, and applies a series of cleaning functions to it in order, then returns the updated corpus.

#The order of cleaning steps makes a difference. For example, if you removeNumbers() and then replace_number(), the second function won't find anything to change!

# Alter the function code to match the instructions
clean_corpus <- function(corpus) {
  # Remove punctuation
  corpus <- tm_map(corpus, removePunctuation)
  # Transform to lower case
  corpus <- tm_map(corpus, content_transformer(tolower))
  # Add more stopwords
  corpus <- tm_map(corpus, removeWords, words = c(stopwords("en"), "coffee", "mug"))
  # Strip whitespace
  corpus <- tm_map(corpus, stripWhitespace)
  return(corpus)
}

# Apply your customized function to the tweet_corp: clean_corp
clean_corp <- clean_corpus(tweet_corp)

# Print out a cleaned up tweet
content(clean_corp[[227]])

# Print out the same tweet in the original form
tweets$text[227]

## Make a document-term matrix
# Hopefully, you are not too tired after all this basic text mining work! Just in case, let's revisit the coffee and get some Starbucks while building a document-term matrix from coffee tweets.

# Beginning with the coffee.csv file, we have used common transformations to produce a clean corpus called clean_corp.

#The document-term matrix is used when you want to have each document represented as a row. This can be useful if you are comparing authors within rows, or the data is arranged chronologically, and you want to preserve the time series. The tm package uses a "simple triplet matrix" class. However, it is often easier to manipulate and examine the object by re-classifying the DTM with as.matrix()

# Create the document-term matrix from the corpus
coffee_dtm <- DocumentTermMatrix(clean_corp)

# Print out coffee_dtm data
coffee_dtm

# Convert coffee_dtm to a matrix
coffee_m <- as.matrix(coffee_dtm)

# Print the dimensions of coffee_m
dim(coffee_m)

# Review a portion of the matrix to get some Starbucks
coffee_m[25:35, c("star", "starbucks")]

# Result: None of those coffee-related tweets talked about stars but several talked about starbucks. Now let's make a term-document matrix. These are the basis for bag of words text mining.

## Make a term-document matrix
# You're almost done with the not-so-exciting foundational work before we get to some fun visualizations and analyses based on the concepts you've learned so far!
  
# In this exercise, you are performing a similar process but taking the transpose of the document-term matrix. In this case, the term-document matrix has terms in the first column and documents across the top as individual column names.

#The TDM is often the matrix used for language analysis. This is because you likely have more terms than authors or documents and life is generally easier when you have more rows than columns. An easy way to start analyzing the information is to change the matrix into a simple matrix using as.matrix() on the TDM.

# Create a term-document matrix from the corpus
coffee_tdm <- TermDocumentMatrix(clean_corp)

# Print coffee_tdm data
coffee_tdm

# Convert coffee_tdm to a matrix
coffee_m <- as.matrix(coffee_tdm)

# Print the dimensions of the matrix
dim(coffee_m)

# Review a portion of the matrix
coffee_m[c("star", "starbucks"), 25:35]
