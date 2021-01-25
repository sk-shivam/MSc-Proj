library(readr)
library(dplyr)
library(magrittr)
library(reshape2)
library(ggplot2)
library(tidytext)
library(tokenizers)
library(DescTools)

Q5<-read.csv('history_database', header=FALSE, sep=':')

