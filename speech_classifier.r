# Natural Language Processing for PS 1903
# Aaron Paczak
# 10/20/18

# Sample pipeline for congressional speech analysis

# Library Imports
library(tm)
library(SnowballC)
library(caTools)
library(ngram)
library(e1071) # Naive Bayes'

# User input for which session to consider, which classifier to use, and which output file to write to
first_session <- readline(prompt="Enter first session considered: ")
last_session <- readline(prompt="Enter last session considered: ")
n_gram <- readline(prompt="N_gram: ")
classifier <- readline(prompt="Enter classifier: ")
output_file <- readline(prompt="Enter output file: ")
first_session <- as.integer(first_session)
last_session <- as.integer(last_session)

# TODO: check users' inputs for validity

# Create a vector of CM's to print out later
vectorCMs <- vector(mode = "list", length = last_session - first_session)

# Main loop for analyzing congressional sessions between the first and last session specified
for (session in first_session:last_session)
{
  # Set up variables for which session and which edition of congress records and get filenames
  session_str = session
  if (session < 100) { session_str = paste(0, session, sep="") }
  print(session)
  edition = './hein-bound/'
  if (session > 111) { edition = './hein-daily/' }
  speech_file = paste(edition, 'speeches_', session_str, '.txt', sep="")
  speakermap_file = paste(edition, session_str, '_SpeakerMap.txt', sep="")
  
  # Importing the datasets and merge to encapsulate gender and speeches
  speeches = read.delim(speech_file, quote = '', stringsAsFactors = FALSE, sep='|')
  speakermap = read.delim(speakermap_file, quote = '', stringsAsFactors = FALSE, sep='|', colClasses=c("NULL", NA, "NULL", "NULL", "NULL", "NULL", NA, "NULL", "NULL", "NULL"))
  total = merge(speeches, speakermap)
  
  # Text Cleaning
  corpus = VCorpus(VectorSource(total$speech))
  corpus = tm_map(corpus, removeNumbers)
  corpus = tm_map(corpus, removePunctuation)
  corpus = tm_map(corpus, removeWords, stopwords())
  corpus = tm_map(corpus, stemDocument)
  corpus = tm_map(corpus, content_transformer(tolower))
  corpus = tm_map(corpus, stripWhitespace)
  
  # Choose how many gram we use lol
  if(n_gram == '1'){
    # Creating the Bag of Words model
    dtm = DocumentTermMatrix(corpus)
    dtm = removeSparseTerms(dtm, 0.99)
  }
  else if(classifier == '2'){
    # Creating the Bigram Model
    BigramTokenizer <-
      function(x)
        unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)
    
    bigram_dtm = DocumentTermMatrix(corpus, control = list(tokenize = BigramTokenizer))
    bigram_dtm = removeSparseTerms(bigram_dtm, 0.99)
    inspect(removeSparseTerms(bigram_dtm[, 1:10], 0.7))
  }
  
  # Create a data fram to be able to input to the classification model
  speeches_df = as.data.frame(as.matrix(bigram_dtm))
  speeches_df$gender = total$gender # adds gender to the dataframe
  
  # Encoding Gender as a factor
  speeches_df$gender = factor(total$gender, levels = c('M', 'F'))
  
  # Splitting the dataset into the Training set and Test set
  set.seed(123)
  split = sample.split(speeches_df$gender, SplitRatio = 0.90)
  training_set = subset(speeches_df, split == TRUE)
  test_set = subset(speeches_df, split == FALSE)
  
  # TODO Check out feature scaling and normalization
  
  # TODO Add other classifiers here
  
  # Creating Naive Bayes' classifier
  classifier = naiveBayes(x = training_set,
                          y = training_set$gender)
  
  # Predicting the Test set results
  y_pred = predict(classifier, newdata = test_set)
  
  # Making the Confusion Matrix
  TestSetGender = test_set$gender
  cm = table(TestSetGender, y_pred)
  
  # TODO log output to actual file here
  # TODO fix output so that it doesnt just go to one line -> json
  
  lapply(cm, write, "bigrams_out.txt", append=TRUE)
  vectorCMs[[session-first_session-1]] <- cm
}

# TODO Log the output to actual file here



