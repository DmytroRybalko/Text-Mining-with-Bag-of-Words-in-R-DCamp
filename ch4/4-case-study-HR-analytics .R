## Step 2: Identifying the text sources
# Employee reviews can come from various sources. If your human resources department had the resources, you could have a third party administer focus groups to interview employees both internally and from your competitor.

# Forbes and others publish articles about the "best places to work", which may mention Amazon and Google. Another source of information might be anonymous online reviews from websites like Indeed, Glassdoor or CareerBliss.

# Here, we'll focus on a collection of anonymous online reviews.

# Print the structure of amzn
str(amzn)

# Create amzn_pros
amzn_pros <- amzn$pros

# Create amzn_cons
amzn_cons <- amzn$cons

# Print the structure of goog
str(goog)

# Create goog_pros
goog_pros <- goog$pros

# Create goog_cons
goog_cons <- goog$cons


## Step 3: Text organization
# qdap_clean the text
qdap_cleaned_amzn_pros <- qdap_clean(amzn_pros)

# Source and create the corpus
amzn_p_corp <- VCorpus(VectorSource(qdap_cleaned_amzn_pros))

# tm_clean the corpus
amzn_pros_corp <- tm_clean(amzn_p_corp)

# qdap_clean the text
qdap_cleaned_amzn_cons <- qdap_clean(amzn_cons)

# Source and create the corpus
amzn_c_corp <- VCorpus(VectorSource(qdap_cleaned_amzn_cons))

# tm_clean the corpus
amzn_cons_corp <- tm_clean(amzn_c_corp)

## The same for google

# qdap_clean the text
qdap_cleaned_amzn_cons <- qdap_clean(amzn_cons)

# Source and create the corpus
amzn_c_corp <- VCorpus(VectorSource(qdap_cleaned_amzn_cons))

# tm_clean the corpus
amzn_cons_corp <- tm_clean(amzn_c_corp)

# qdap clean the text
qdap_cleaned_goog_cons <- qdap_clean(goog_cons)

# Source and create the corpus
goog_c_corp <- VCorpus(VectorSource(qdap_cleaned_goog_cons))

# tm clean the corpus
goog_cons_corp <- tm_clean(goog_c_corp)

## Steps 4 & 5: Feature extraction & analysis
# 2. Feature extraction
#The next step, number 4, is where you extract features from the text. This can take the form of sentiment scoring, or in this case, organizing the clean corpora text into a bi-gram TDM. To do so, you use RWeka like in chapter three's tokenizer function. You use it as a control when constructing the TermDocumentMatrix. In this example, tokenizer is applied to the amazon positive employee reviews to make amzn_p_tdm. In this case study, making the bi-gram TDM is the only major feature extraction that you are performing on your corpora.

#3. Get term frequencies
#The fifth step is to do some analysis on the extracted text features. An initial analysis is simply exploring your data to make sure it is in the intended form. This is one of the basic exercises from the chapter where you change the TDM to a matrix, calculate rowSums, sort the bigrams in decreasing order and then review the top 1 to 5 tokens. So not only have you extracted the bigrams from the text, but you are also extracting the most frequent bigrams to inform your analysis.

#4. Create visuals with plotrix
#Within steps 4 and 5, you will do a lot of feature extraction because you will have 4 bi-gram TDMs representing your four corpora. For the analysis, you now have some foundation to extract word associations and make some text-based plots. One of the visuals you are going to make is shown here. It's a pyramid plot from the plotrix package. In this exercise, you will find the common_words from negative amazon and Google bi-grams. Next, you calculate the absolute difference between the two vectors. Then, add the difference calculation to the words in common using cbind and order the entire data frame by the difference column with decreasing equals TRUE. Next, you create a top15_df data frame before passing it to the pyramid-plot with some aesthetics. This is just one of the interesting plots you will make during this case study, which should help lead you to a conclusion.

## == Feature extraction & analysis: amzn_pros
#amzn_pros_corp, amzn_cons_corp, goog_pros_corp, and goog_cons_corp have all been preprocessed, so now you can extract the features you want to examine. Since you are using the bag of words approach, you decide to create a bigram TermDocumentMatrix for Amazon's positive reviews corpus, amzn_pros_corp. From this, you can quickly create a wordcloud() to understand what phrases people positively associate with working at Amazon.

# Create amzn_p_tdm
amzn_p_tdm <- TermDocumentMatrix(
  amzn_pros_corp,
  control = list(tokenize = tokenizer))

# Create amzn_p_tdm_m
amzn_p_tdm_m <- as.matrix(amzn_p_tdm)

# Create amzn_p_freq
amzn_p_freq <- rowSums(amzn_p_tdm_m)

# Plot a word cloud using amzn_p_freq values
wordcloud(names(amzn_p_freq), amzn_p_freq, max.words = 25, color = "blue")

## == Feature extraction & analysis: amzn_cons
#You now decide to contrast this with the amzn_cons_corp corpus in another bigram TDM. Of course, you expect to see some different phrases in your word cloud.

#Once again, you will use this custom function to extract your bigram features for the visual:
  
# tokenizer <- function(x) 
#    NGramTokenizer(x, Weka_control(min = 2, max = 2))
# Create amzn_p_tdm
amzn_p_tdm <- TermDocumentMatrix(
  amzn_pros_corp,
  control = list(tokenize = tokenizer))

# Create amzn_p_tdm_m
amzn_p_tdm_m <- as.matrix(amzn_p_tdm)

# Create amzn_p_freq
amzn_p_freq <- rowSums(amzn_p_tdm_m)

# Plot a word cloud using amzn_p_freq values
wordcloud(names(amzn_p_freq), amzn_p_freq, max.words = 25, color = "blue")

# The same for cons
# Create amzn_c_tdm
amzm_c_tdm <- TermDocumentMatrix(
  amzn_cons_corp,
  control = list(tokenize = tokenizer)
)

# Create amzn_c_tdm_m
amzn_c_tdm_m <- as.matrix(amzn_c_tdm)

# Create amzn_c_freq
amzn_c_freq <- rowSums(amzn_c_tdm_m)

# Plot a word cloud of negative Amazon bigrams
wordcloud(names(amzn_c_freq), amzn_c_freq, max.words = 25, color = "red")

## == amzn_cons dendrogram
# It seems there is a strong indication of long working hours and poor work-life balance in the reviews. As a simple clustering technique, you decide to perform a hierarchical cluster and create a dendrogram to see how connected these phrases are.

# Create amzn_c_tdm
amzn_c_tdm <- TermDocumentMatrix(
  amzn_cons_corp,
  control = list(tokenize = tokenizer)
)

# Print amzn_c_tdm to the console
amzn_c_tdm

# Create amzn_c_tdm2 by removing sparse terms 
amzn_c_tdm2 <- removeSparseTerms(amzn_c_tdm, sparse = 0.993)

# Create hc as a cluster of distance values
hc <- hclust(dist(amzn_c_tdm2),
             method = "complete")

# Produce a plot of hc
plot(hc)

# Word association
# As expected, you see similar topics throughout the dendrogram. Switching back to positive comments, you decide to examine top phrases that appeared in the word clouds. You hope to find associated terms using the findAssocs()function from tm. You want to check for something surprising now that you have learned of long hours and a lack of work-life balance.

# Create amzn_p_tdm
amzn_p_tdm <- TermDocumentMatrix(
  amzn_pros_corp,
  control = list(tokenize = tokenizer)
)

# Create amzn_p_m
amzn_p_m <- as.matrix(amzn_p_tdm)

# Create amzn_p_freq
amzn_p_freq <- rowSums(amzn_p_m)

# Create term_frequency
term_frequency <- sort(amzn_p_freq, decreasing = TRUE)

# Print the 5 most common terms
term_frequency[1:5]

# Find associations with fast-paced
findAssocs(amzn_p_tdm, "fast paced", 0.2)

## == Quick review of Google reviews
#You decide to create a comparison.cloud() of Google's positive and negative reviews for comparison to Amazon. This will give you a quick understanding of top terms without having to spend as much time as you did, examining the Amazon reviews in the previous exercises.

#We've provided you with a corpus all_goog_corpus, which has 500 positive and 500 negative reviews for Google. Here, you'll clean the corpus and create a comparison cloud comparing the common words in both pro and con reviews.

# Create all_goog_corp
all_goog_corp <- tm_clean(all_goog_corpus)

# Create all_tdm
all_tdm <- TermDocumentMatrix(all_goog_corp)

# Create all_m
all_m <- as.matrix(all_tdm)

# Build a comparison cloud
comparison.cloud(all_m, 
                 max.words = 100, 
                 colors = c("#F44336", "#2196f3"))

## == Cage match! Amazon vs. Google pro reviews
#Amazon's positive reviews appear to mention bigrams such as "good benefits", while its negative reviews focus on bigrams such as "workload" and "work-life balance" issues.

#In contrast, Google's positive reviews mention "great food", "perks", "smart people", and "fun culture", among other things. Google's negative reviews discuss "politics", "getting big", "bureaucracy", and "middle management".

#You decide to make a pyramid plot lining up positive reviews for Amazon and Google so you can compare the differences between any shared bigrams.
#We have preloaded a data frame, all_tdm_df, consisting of terms and corresponding AmazonPro, and GooglePro bigram frequencies. Using this data frame, you will identify the top 5 bigrams that are shared between the two corpora.

# Filter to words in common and create an absolute diff column
common_words <- all_tdm_df %>% 
  filter(
    AmazonPro != 0,
    GooglePro != 0
  ) %>%
  mutate(diff = abs(AmazonPro - GooglePro))

# Extract top 5 common bigrams
(top5_df <- top_n(common_words, 5, diff))

# Create the pyramid plot
pyramid.plot(top5_df$AmazonPro, top5_df$GooglePro, 
             labels = top5_df$terms, gap = 12, 
             top.labels = c("Amzn", "Pro Words", "Goog"), 
             main = "Words in Common", unit = NULL)

## == Cage match, part 2! Negative reviews
# In both organizations, people mentioned "culture" and "smart people", so there are some similar positive aspects between the two companies. However, with the pyramid plot, you can start to infer degrees of positive features of the work environments.

# You now decide to turn your attention to negative reviews and make the same visual. This time you already have the common_words data frame in your workspace. However, the common bigrams in this exercise come from negative employee reviews.

# Extract top 5 common bigrams
(top5_df <- top_n(common_words, 5, diff))

# Create a pyramid plot
pyramid.plot(
  # Amazon on the left
  top5_df$AmazonNeg,
  # Google on the right
  top5_df$GoogleNeg,
  # Use terms for labels
  labels = top5_df$terms,
  # Set the gap to 12
  gap = 12,
  # Set top.labels to "Amzn", "Neg Words" & "Goog"
  top.labels = c("Amzn", "Neg Words", "Goog"),
  main = "Words in Common", 
  unit = NULL
)

# You saw that Amazon's negative reviews more often mention long hours.
# 