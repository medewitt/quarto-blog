# https://github.com/casey/just#shell

all: render redirects

# Render everything
render:
  quarto render

# Build redirects
redirects:
  Rscript --vanilla _build_redirects.R

# Copy thoughts over
thoughts:
  cd thoughts; git pull origin main;
  cd ..;
  cp thoughts/index.html _site/thoughts/index.html
  cp thoughts/feed.xml _site/thoughts/feed.xml
  cp thoughts/style.css _site/thoughts/style.css
  cp -rf thoughts/img/ _site/thoughts/img

# Update submodule
updatethoughts:
  git submodule update