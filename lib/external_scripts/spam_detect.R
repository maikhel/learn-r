#Load the required library silently
suppressPackageStartupMessages(require(jsonlite))
suppressPackageStartupMessages(require(optparse))

# training set
spam <- list(c("buy", "drugs", "online", "from", "our", "pharma"),
            c("buy", "insurance", "at", "low", "prices"),
            c("amazing", "stuff", "limited", "edition"),
            c("bargain", "only", "today"),
            c("click", "to", "buy", "free", "drugs"),
            c("earn", "million", "dollars", "in", "two", "weeks"),
            c("double", "your", "income", "in", "three", "days"))

legitimate <- list(c("newsletter", "from", "your", "favorite", "website"),
                   c("i", "was", "writing", "for", "ruby", "advice"),
                   c("new", "ruby", "library"),
                   c("service", "objects", "in", "rails"),
                   c("why", "ruby", "is", "better", "than", "go"),
                   c("rspec", "good", "practices"),
                   c("good", "article", "on", "rails"))

# training
categories = 2
priors <- c()
total <- length(spam) + length(legitimate)
priors[1] <- length(spam) / total
priors[2] <- length(legitimate) / total

training <-list(spam, legitimate)

features <- list();
zeroOccurrences = list()
for (category in 1:categories) {
    categoryFeatures <- list();
    singleOccurrence = 1 / length(training[[category]])
    zeroOccurrences[[category]] = singleOccurrence
    for (sampleMail in training[[category]]) {
        for (word in sampleMail) {
            if (word %in% names(categoryFeatures)) {
                categoryFeatures[[word]] = categoryFeatures[[word]] + singleOccurrence
            } else {
                categoryFeatures[[word]] = zeroOccurrences[[category]] + singleOccurrence
            }
        }
    }
    features[[category]] <- categoryFeatures
}


score <- function (test_mail, category) {
    score <- priors[category]
    categoryFeatures = features[[category]]
    for (word in test_mail) {
        if (word %in% names(categoryFeatures)) {
            score <- score * categoryFeatures[[word]]
        } else {
            score <- score * zeroOccurrences[[category]]
        }
    }
    return(score)
}

# classifier
classify <- function(test_mail) {
    scores = c()
    for (i in 1:categories) {
        scores[i] = score(test_mail, i)
    }
    # print(scores)
    result <- which(scores==max(scores))
    list(scores=scores,result=result)
}

# Set up the script option parsing
option_list = list(
  make_option(c("-p", "--params"), action="store", default=NA, type='character',
              help="a valid JSON")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

# Validate the Option parameters
if (is.null(opt$params) | !validate(opt$params)){
  print_help(opt_parser)
  stop("At least one argument must be supplied or the JSON must be valid.", call.=FALSE)
}

params <- fromJSON(opt$params)
words <- params$words

out <- classify(words)

# Return the JSON
toJSON(out,auto_unbox=TRUE)
