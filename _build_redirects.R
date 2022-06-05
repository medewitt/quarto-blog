z <- readLines(here::here("_site", "_redirects"))
y <- readLines(here::here("_redirects"))

out <- c(z,y)

writeLines(out, here::here("_site", "_redirects"))
