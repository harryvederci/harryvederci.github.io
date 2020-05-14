pip3 install -U -r requirements.txt --user && \
  mkdir -p .data && \
  rm .data/data.db || true && \
  for f in input/*.csv
    do
        sqlite-utils insert .data/data.db ${f%.*} $f --csv
    done

