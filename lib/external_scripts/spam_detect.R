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
    print(scores)
    which(scores==max(scores))
}


# https://quickleft.com/blog/running-r-script-ruby-rails-app/



# validation set
print(classify(c("ruby", "on", "rails", "architecture")))
print(classify(c("free", "drugs")))
print(classify(c("r", "article")))
print(classify(c("generate", "100000", "dollar", "income", "from", "home")))
print(classify(c("rails", "changelog")))
print(classify(c("buy", "car", "with", "huge", "discount")))
print(classify(c("best", "ruby", "libraries")))
