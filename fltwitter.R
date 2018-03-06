library('twitteR')
devtools::install_github("jrowen/twitteR", ref = "oauth_httr_1_0")
library('streamR')
library('ROAuth')
library('RCurl')
library('dplyr')
library('base64enc')
library('httr')

consumer_key <- "HjpizPpXYCXQB3fm7eBEagDtQ"
consumer_secret<- "nELK0NHx1tKhTnqSA0K5fKDPKi7t5vnXqdmUdEPMN6otKQRbSd"
access_token<- "921397085898924033-1NVm7InRpat88iBzun2JrT7BdPjj4Ny"
access_token_secret<- "7cNcPuIG2SXKRXoy8BYAsG4oD94e1mdx4XWUozFzOoosz"

reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL<- "https://api.twitter.com/oauth/access_token"
authURL<- "https://api.twitter.com/oauth/authorize"

twitCred<- OAuthFactory$new(consumerKey=consumer_key,consumerSecret=consumer_secret,
                            requestURL=reqURL,accessURL=accessURL,authURL=authURL)

twitCred$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
save(twitCred, file = "twitCred.RData")

setup_twitter_oauth(consumer_key, consumer_secret)
