# New Haven Housing Scrape Redux

# Adaptation from a homework assignment. I know there are R 
# packages to handle scraping, but for class we were not permitted
# to use outside packages for this exercise. 

# setwd("/Users/katdevlin/Desktop/housing_scrape")

this <- file.path("http://gis.vgsi.com/newhavenct/",
                  "Parcel.aspx?Pid=1")
z <- scan(this, what="", sep="\n")

# If we look at `z` we can see the contents from the first database entry 
# were successfully puled in. Now let's scrape a bunch. The database 
# contains more than 27K entries; for this demo I'm capping it at 100.

baseurl <- file.path("http://gis.vgsi.com/newhavenct/",
                     "Parcel.aspx?Pid=XXX")

# Tons of variables. Let's look at assessment price, # of bedrooms,
# area of the living spaces.

x <- data.frame(Assessment=rep(NA, 100), Bedrooms=rep(NA,100),
                LvngArea=rep(NA,100))

for (i in 1:100) {
  thisurl <- gsub("XXX", i, baseurl)
  z <- scan(thisurl, what="", sep="\n")
  temp <- z[grep(".*GenAssessment.*</dd>", z)]
  temp <- gsub(".*\\$([0-9,]+).*", "\\1", temp)
  temp <- gsub(",","", temp)
  temp2 <- z[grep("Bed", z, fixed=TRUE)]
  temp2 <- gsub(".*([0-9]+).*", "\\1", temp2)
  temp3 <- z[grep("BldArea", z, fixed=TRUE)]
  temp3 <- gsub(".*>([0-9]+).*", "\\1", temp3)
  x$Assessment[i] <- as.numeric(temp)
  x$Bedrooms[i] <- as.numeric(temp2)
  x$LvngArea[i] <- as.numeric(temp3)
} 

# Turn the data into a .csv
write.csv(x, file="housing_scrape.csv")

# Check it all worked.
head(x)
tail(x)
#
for (i in 1:ncol(x)) {
  print(str(x[,i])) 
}
