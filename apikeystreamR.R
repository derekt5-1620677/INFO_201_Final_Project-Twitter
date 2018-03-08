library(httr)
library(ROAuth)
library(twitteR)
library(streamR)
library(RCurl)
library(dplyr)
library(base64enc)
library(devtools)

devtools::install_github("pablobarbera/streamR/streamR") # from GitHub

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "NEUJd9hnnlJmqMv6MLnFafFtr"
consumerSecret <- "HkBcpUGx4gAtHbomcwm3CNSiXgranyBWORHtyhI85vND8utpTy"
my_oauth <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret, 
                             requestURL = requestURL, accessURL = accessURL, authURL = authURL)

# my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
# save(my_oauth, file = "my_oauth.Rdata")

load("my_oauth.Rdata")
# consumer_key <- "NEUJd9hnnlJmqMv6MLnFafFtr"
# consumer_secret <- "HkBcpUGx4gAtHbomcwm3CNSiXgranyBWORHtyhI85vND8utpTy"
# access_token <- "	921397085898924033-4ZmEl05oZHlvaLsduptorkLHEQ9huN8"
# access_secret <- "aIVdq9d9XY87gUniUbaCB7D4IGMmNDLpnsysmjriyrY0d"
