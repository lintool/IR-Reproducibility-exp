read.data <- function(f) {
	x <- read.table(f, header=T, row.names=1)
	y <- as.matrix(x)[,order(colMeans(x))]
	map <- apply(y, 2, mean)
	map.diff <- outer(map, map, "-")

	run <- colnames(y)
	run.diff <- outer(run, run, function(x,y) paste(x,"-",y))

	dat <- data.frame(y=as.vector(y), sys=rep(run, each=nrow(y)), top=as.factor(1:nrow(y)))

	list(y=y, map=map, map.diff=map.diff, df=dat, run=run, run.diff=run.diff)
}

t.tests <- function(dat, which.ret=lower.tri) {
	y <- dat$y
	map <- dat$y
	map.diff <- dat$map.diff
	run.diff <- dat$run.diff
	if (is.null(dat$p.t)) {
		dat$p.t <- apply(y, 2, function(i) apply(y, 2, function(j) t.test(i-j)$p.value))
	}
	data.frame(pair=run.diff[which.ret(dat$p.t)], map.diff=map.diff[which.ret(dat$p.t)], p=dat$p.t[which.ret(dat$p.t)])
}

hsd.tests <- function(dat) {
	y <- dat$y
	map <- dat$y
	map.diff <- dat$map.diff
	run.diff <- dat$run.diff
	df <- dat$df
	m <- aov(y ~ sys+Error(top), data=df)
	mse <- sum(resid(m[[3]])^2)/df.residual(m[[3]])
	p.hsd <- ptukey(map.diff/(sqrt(mse/nrow(y))), ncol(y), df.residual(m[[3]]), lower=F)
	data.frame(pair=run.diff[lower.tri(p.hsd)], map.diff=map.diff[lower.tri(p.hsd)], p=p.hsd[lower.tri(p.hsd)])
}
