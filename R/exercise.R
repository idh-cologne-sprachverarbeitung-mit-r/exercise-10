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

# a)
barplot(df$tokens)

# b)
colMatrix <- matrix(c(df$green,df$red,df$blue), ncol = 3)
colMatrix <- t(colMatrix)
colnames(colMatrix) <- 1:99
for (i in 99:1) {
    if (colMatrix[,i][1] == 0 && colMatrix[,i][2] == 0 && colMatrix[,i][3] == 0) {
        colMatrix <- colMatrix[,-i]
    } 
}
barplot(colMatrix, col = c("green", "red", "blue"))

# c)
df <- dist(df, method = "manhattan")
heatmap(dis, Rowv=NA, Colv=NA)

# d)
layout(mat = matrix(c(1, 2), ncol=2), widths = c(5, 1))
barplot(df$sentences, xlab = "Documents")
boxplot(df$sentences)

# e) 
# erst mal Package cowplot downloaden
align_plots(align = "v", axis = c("b", "t"))


