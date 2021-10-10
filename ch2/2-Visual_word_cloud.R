## == Frequent terms with tm
#Now that you know how to make a term-document matrix, as well as its transpose, the document-term matrix, we will use it as the basis for some analysis. In order to analyze it, we need to change it to a simple matrix, as we did in chapter 1 using as.matrix().

#Calling rowSums() on your newly made matrix aggregates all the terms used in a passage. Once you have the rowSums(), you can sort() them with decreasing = TRUE, so you can focus on the most common terms.

#Lastly, you can make a barplot() of the top 5 terms of term_frequency with the following code.
#
# Convert coffee_tdm to a matrix
coffee_m <- as.matrix(coffee_tdm)

# Calculate the row sums of coffee_m
term_frequency <- rowSums(coffee_m)

# Sort term_frequency in decreasing order
term_frequency <- sort(term_frequency, decreasing = TRUE)

# View the top 10 most common words
term_frequency[1:10]

# Plot a barchart of the 10 most common words
barplot(term_frequency[1:10], col = "tan", las = 2)

## Frequent terms with qdap
#If you are OK giving up some control over the exact preprocessing steps, then a fast way to get frequent terms is with freq_terms() from qdap.

#The function accepts a text variable, which, in our case, is the tweets$text vector. You can specify the top number of terms to show with the top argument, a vector of stop words to remove with the stopwords argument, and the minimum character length of a word to be included with the at.least argument. qdap has its own list of stop words that differ from those in tm. Our exercise will show you how to use either and compare their results.

#Making a basic plot of the results is easy. Just call plot() on the freq_terms() object.

# Create frequency
frequency <- freq_terms(
  tweets$text, 
  top = 10, 
  at.least = 3, 
  stopwords = "Top200Words"
)

# Make a frequency bar chart
plot(frequency)

## A simple word cloud
#At this point, you have had too much coffee. Plus, seeing the top words such as "shop", "morning", and "drinking" among others just isn't all that insightful.

#In celebration of making it this far, let's try our hand on another batch of 1000 tweets. For now, you won't know what they have in common, but let's see if you can figure it out using a word cloud. The tweets' term frequency values are preloaded in your workspace.

#A word cloud is a visualization of terms. In a word cloud, size is often scaled to frequency, and in some cases, the colors may indicate another measurement. For now, we're keeping it simple: size is related to individual word frequency, and we are just selecting a single color.

# Load wordcloud package
library(wordcloud)

# Print the first 10 entries in term_frequency
term_frequency[1:10]

# Vector of terms
terms_vec <- names(term_frequency)

# Create a word cloud for the values in word_freqs
wordcloud(terms_vec, term_frequency, max.words = 50, colors = "red")

## Stop words and word clouds
#Now that you are in the text mining mindset, sitting down for a nice glass of chardonnay, we need to dig deeper. In the last word cloud, "chardonnay" dominated the visual. It was so dominant that you couldn't draw out any other interesting insights.

#Let's change the stop words to include "chardonnay" to see what other words are common, yet were originally drowned out.

#Your workspace has a cleaned version of chardonnay tweets, but now let's remove some non-insightful terms. This exercise uses content() to show you a specific tweet for comparison. Remember to use double brackets to index the corpus list.

# Review a "cleaned" tweet
content(chardonnay_corp[[24]])

# Add to stopwords
stops <- c(stopwords("en"), "chardonnay")

# Review last 6 stopwords 
tail(stops)

# Apply to a corpus
cleaned_chardonnay_corp <- tm_map(chardonnay_corp, removeWords, stops)

# Review a "cleaned" tweet again
content(cleaned_chardonnay_corp[[24]])

# Sort the chardonnay_words in descending order
sorted_chardonnay_words <- sort(chardonnay_words, decreasing = TRUE)

# Print the 6 most frequent chardonnay terms
head(sorted_chardonnay_words)

# Get a terms vector
terms_vec <- names(chardonnay_words)

# Create a wordcloud for the values in word_freqs
wordcloud(terms_vec, chardonnay_words, max.words = 50, colors = "red")

## Improve word cloud colors
#So far, you have specified only a single hexadecimal color to make your word clouds. You can easily improve the appearance of a word cloud. Instead of the #AD1DA5 in the code below, you can specify a vector of colors to make certain words stand out or to fit an existing color scheme.
#wordcloud(chardonnay_freqs$term, 
#          chardonnay_freqs$num, 
#          max.words = 100, 
#          colors = "#AD1DA5")

#To change the colors argument of the wordcloud() function, you can use a vector of named colors like c("chartreuse", "cornflowerblue", "darkorange"). The function colors() will list all 657 named colors. You can also use this PDF as a reference.

#In this exercise you will use "grey80", "darkgoldenrod1", and "tomato" as colors. This is a good starting palette to highlight terms because "tomato" stands out more than "grey80". It is a best practice to start with three colors, each with increasing vibrancy. Doing so will naturally divide the term frequency into "low", "medium", and "high" for easier viewing.

# Print the list of colors
colors()

# Print the word cloud with the specified colors
wordcloud(chardonnay_freqs$term, chardonnay_freqs$num,
          max.words = 100,
          colors = c("grey80", "darkgoldenrod1", "tomato"))

## Use prebuilt color palettes
#In celebration of your text mining skills, you may have had too many glasses of chardonnay while listening to Marvin Gaye. So if you find yourself unable to pick colors on your own, you can use the viridisLite package. viridisLite color schemes are perceptually-uniform, both in regular form and when converted to black-and-white. The colors are also designed to be perceived by readers with color blindness.

# Select 5 colors 
color_pal <- cividis(n = 5)

# Examine the palette output
color_pal

# Create a word cloud with the selected palette
wordcloud(chardonnay_freqs$term,
          chardonnay_freqs$num,
          max.words = 100,
          colors = color_pal)

## Find common words
#Say you want to visualize common words across multiple documents. You can do this with commonality.cloud().

#Each of our coffee and chardonnay corpora is composed of many individual tweets. To treat the coffee tweets as a single document and likewise for chardonnay, you paste() together all the tweets in each corpus along with the parameter collapse = " ". This collapses all tweets (separated by a space) into a single vector. Then you can create a single vector containing the two collapsed documents.

#a_single_string <- paste(a_character_vector, collapse = " ")
#Once you're done with these steps, you can take the same approach you've seen before to create a VCorpus() based on a VectorSource from the all_tweets object.

# Create all_coffee
all_coffee <- paste(coffee_tweets$text, collapse = " ")

# Create all_chardonnay
all_chardonnay <- paste(chardonnay_tweets$text, collapse = " ")

# Create all_tweets
all_tweets <- c(all_coffee, all_chardonnay)

# Convert to a vector source
all_tweets <- VectorSource(all_tweets)

# Create all_corpus
all_corpus <- VCorpus(all_tweets)

## Visualize common words
#Now that you have a corpus filled with words used in both the chardonnay and coffee tweets files, you can clean the corpus, convert it into a TermDocumentMatrix, and then a matrix to prepare it for a commonality.cloud().

#The commonality.cloud() function accepts this matrix object, plus additional arguments like max.words and colors to further customize the plot.

# Visualize dissimilar words
# Say you want to visualize the words not in common. To do this, you can also use comparison.cloud(), and the steps are quite similar with one main difference.

#Like when you were searching for words in common, you start by unifying the tweets into distinct corpora and combining them into their own VCorpus() object. Next apply a clean_corpus() function and organize it into a TermDocumentMatrix.

#To keep track of what words belong to coffee versus chardonnay, you can set the column names of the TDM like this:
  
#colnames(all_tdm) <- c("chardonnay", "coffee")
#Lastly, convert the object to a matrix using as.matrix() for use in comparison.cloud(). For every distinct corpora passed to the comparison.cloud() you can specify a color, as in colors = c("red", "yellow", "green"), to make the sections distinguishable.

## == Polarized tag cloud
# Commonality clouds show words that are shared across documents. One interesting thing that they can't show you is which of those words appear more commonly in one document compared to another. For this, you need a pyramid plot; these can be generated using pyramid.plot() from the plotrix package.

#First, some manipulation is required to get the data in a suitable form. This is most easily done by converting it to a data frame and using dplyr. Given a matrix of word counts, as created by as.matrix(tdm), you need to end up with a data frame with three columns:

#The words contained in each document.
#The counts of those words from document 1.
#The counts of those words from document 2.
#Then pyramid.plot() using

#pyramid.plot(word_count_data$count1, word_count_data$count2, word_count_data$word)
#There are some additional arguments to improve the cosmetic appearance of the plot.

#Now you'll explore words that are common in chardonnay tweets, but rare in coffee tweets. all_dtm_m is created for you.

top25_df <- all_tdm_m %>%
  # Convert to data frame
  as_data_frame(rownames = "word") %>% 
  # Keep rows where word appears everywhere
  filter_all(all_vars(. > 0)) %>% 
  # Get difference in counts
  mutate(difference = chardonnay - coffee) %>% 
  # Keep rows with biggest difference
  top_n(25, wt = difference) %>% 
  # Arrange by descending difference
  arrange(desc(difference))

# Pyramid plots let you see words that are common in one document, but rare in another.
pyramid.plot(
  # Chardonnay counts
  top25_df$chardonnay, 
  # Coffee counts
  top25_df$coffee, 
  # Words
  labels = top25_df$word, 
  top.labels = c("Chardonnay", "Words", "Coffee"), 
  main = "Words in Common", 
  unit = NULL,
  gap = 8
)


