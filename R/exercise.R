readCorpus <- function(dirname="data", fPattern="*.txt", tokenize=TRUE, scanSep=ifelse(tokenize,"","\n")) {
	files <- dir(dirname, pattern=fPattern)
	lapply(files, function(x) {
		scan(file.path(dirname,x), what=character(), quote=NULL,sep=scanSep)
	})
}


corpus <- readCorpus("data", tokenize=TRUE)

ttr <- function(x) { length(levels(factor(x)))/length(x) }
ucWords <- function(x) { length(grep("\\b[A-Z]+\\b", x)) }
sentences <- function(x) { length(grep("\\b\\.\\b", x)) }
wc <- function(x, p) { length(grep(p, x)) / length(x)}

df <- data.frame(
  tokens=unlist(lapply(corpus, length)),
  sentences=unlist(lapply(corpus, sentences)),
  ttr=unlist(lapply(corpus, ttr)),
  uc=unlist(lapply(corpus, ucWords)),
  articles=unlist(lapply(corpus, wc, p="\\b(an?|the)\\b")),
  us=unlist(lapply(corpus, wc, p="\\bUSA?\\b")),
  colors=unlist(lapply(corpus, wc, p="\\b(green|blue|red|yellow|white|black)\\b")),
  green=unlist(lapply(corpus, wc, p="\\b(green)\\b")),
  red=unlist(lapply(corpus, wc, p="\\b(red)\\b")),
  blue=unlist(lapply(corpus, wc, p="\\b(blue)\\b"))
)


setwd("C:\\Users\\Lukas\\exercise-10")


#a)

barplot(df$tokens)


#b)

greensBool <- df$green > 0
bluesBool <- df$blue > 0
redsBool <- df$red > 0

greensNum <- df$green[greensBool]
bluesNum <- df$blue[bluesBool]
redsNum <- df$red[redsBool]

allColors <- rbind(greensNum, bluesNum, redsNum)

barplot(
  allColors,
  col=c("green", "red", "blue")
  )

#c)

heatmap(
  as.matrix(dist(df, "manhattan")),
  Colv = NA,
  Rowv = NA)

#d)

layout(
  matrix(c(1,2), nrow = 1, ncol = 2),
  widths = c(5, 1)
)
barplot(df$sentences, xlab="Documents", ylab="Sentences")
boxplot(df$sentences, frame = FALSE)

#e)

layout(
  matrix(c(1,2), nrow = 1, ncol = 2),
  widths = c(5, 1)
)
barplot(df$sentences, ylim=c(0, 1750),  xlab="Documents", ylab="Sentences")
boxplot(df$sentences, ylim=c(0, 1750),  frame = FALSE)

