#!/bin/bash

rm -rf out/*
mkdir -p out

for f in pages/*.html
do
  name=$(basename "${f}")
  if [ "${name}" == "home" ]
  then
    continue
  fi

  cat partials/header.html "pages/${name}" partials/footer.html > "out/${name}"
  cp -r assets/ out/assets
done

cat partials/header.html "pages/home.html" partials/footer.html > "out/index.html"
