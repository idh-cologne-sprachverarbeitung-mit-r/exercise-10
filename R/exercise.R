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

#a

barplot(df$tokens, xlab="documents", ylab="tokens")

#b

green.doc <- (df$green) > 0
vec.doc.green <- df$green[green.doc] 
blue.green.red.doc <- ((df$green)|(df$red)|(df$blue))
df.colors <- rbind(df$green, df$red, df$blue)
vec.doc.colors <- df.colors[, blue.green.red.doc]

barplot(vec.doc.colors, col=c("green", "red", "blue"), xlab="documents", ylab="colors")

#c

heatmap(as.matrix(dist(df, "manhattan")), Colv = NA, Rowv = NA)

#d/e
mat <- matrix(c(1,2), byrow=TRUE, nrow = 1, ncol = 2)
layout(mat, widths = c(2.5, 0.5))
barplot(df$sentences, ylim=c(0, 1600), yaxs="i", xlab="Documents", ylab="Sentences")
boxplot(df$sentences, ylim=c(0, 1600), yaxs="i", frame = FALSE)

