library(SentimentAnalysis)
library(readtext)
library(sentimentr)
library(dplyr)
library(ggplot2)

# Read the PDF file
pdf_text <- readtext("C:/Users/Lenovo/Desktop/kababa/Upwork/Tina/project 2 data cleaning/Fomc minutes/Merged PDF File for all FOMC minutes.pdf")

# Perform sentiment analysis
sentiment_scores <- sentiment(pdf_text$text)

# Print the sentiment scores
print(sentiment_scores)

#sentiment ranking
attach(sentiment_scores)
ranks<-ifelse(sentiment<=-0.05,"Negative",ifelse(sentiment>=0.05,"Positive","Neutral"))
sentiment_scores%>% cbind(ranks)

#visuallizing my findings
ggplot(sentiment_scores, aes(x = ranks, y=(n=ranks), fill = sentiment_scores$sentiment)) +
  geom_bar(stat = "identity") +
  ggtitle("Sentiment Scores") +
  xlab("Sentiment") +
  ylab("Score")

#method 2 of obtaining the sentiments
library(tidyverse)
library(syuzhet)
library(tidytext)

# using syuzhet package
text.df<-tibble(text=str_to_lower(pdf_text$text))
emotions<-get_nrc_sentiment(text.df$text)
emo_bar<-colSums(emotions)
emo_sum<-data.frame(count=emo_bar,emotions=names(emo_bar))

#visualizing my findings
ggplot(emo_sum,aes(x=reorder(emotions,-count),y=count))+
  geom_bar(stat ="identity")+
  ggtitle("Sentiment Scores for FOMC minutes") +
  xlab("Sentiment") +
  ylab("frequency")
# sentiment analysis using the tidytext package and "bing" lexicon
bing_words_counts<-text.df%>%unnest_tokens(output = word,input = text)%>%
  inner_join(get_sentiments("bing"))%>%
  count(word,sentiment,sort=TRUE)

#select top ten words by sentiment
bing_top_10_words_by_sentiment<-bing_words_counts %>%
  group_by(sentiment)%>%
  slice_max(order_by = n,n=10)%>%
  ungroup()%>%
  mutate(word=reorder(word,n))
bing_top_10_words_by_sentiment

#bar plot showing contribution of words to sentiment
bing_top_10_words_by_sentiment%>%
  ggplot(aes(word,n,fill=sentiment))+
  geom_col(show.legend = FALSE)+
  facet_wrap(~sentiment,scales = "free_y")+
  labs(x=NULL,y="contribution to sentiment")+
  ggtitle("Bar plots showing contribution of words to sentiment")+
  coord_flip()
#tokenized dataframe
# Load the required packages
library(pdftools)
library(tidytext)

# Read the PDF file into R
#NB: the pdf was already loaded as pdf_text above
# Convert the text into a data frame
df <- data.frame(text =str_to_lower(pdf_text))

# Tokenize the text using the unnest_tokens function from the tidytext package
df_tokens <- df %>%
  unnest_tokens(word, text)

# The resulting tokenized data is stored in a new column of the dataframe
print(df_tokens)

#exporting data from my global environment
# Set the path to your desired directory
path <- "C:/Users/Lenovo/Desktop/Upwork/Tina/project 2 data cleaning/Tokenized dataframe.csv"

# Export the data frame to a CSV file in the specified directory
write.csv(df_tokens, file = paste0(path, "Tokenized dataframe.csv"))
write.csv(emo_sum, file = paste0(path, "Tokenized dataframe2.csv"))



###########WOrd cloud ############
wordcld_data<-read.csv("C:/Users/Lenovo/Desktop/kababa/Github/Sentiment Analysis/Tokenized dataframe.csv")
str(wordcld_data)
library(wordcloud2)
library(RColorBrewer)
library(tidyverse)
library(stopwords)

df_tokens_clean <- wordcld_data %>%
  filter(!word %in% stopwords("en")) %>%
  filter(str_detect(word, "^[a-z]+$"))  # keep only words

# Create a word frequency table
word_freq <- df_tokens_clean %>%
  count(word, sort = TRUE)

# Interactive word cloud
wordcloud2(data = word_freq, size = 0.8, color = 'random-dark')





