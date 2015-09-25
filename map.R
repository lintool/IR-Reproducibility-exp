#!/usr/bin/Rscript

source('tukey.R')
dat <- read.data('map')
r <- hsd.tests(dat)

# print the rows that are sig
r[r$p < 0.05,]
