#!/bin/bash

content=`wget -qO - "https://www.ncbi.nlm.nih.gov/geo/browse/?view=samples&sort=acc&page={}&display=500"`

samples_block=`echo $content | grep -oP "<div id=\"count\" class=\"commas\">.*?</div>"`
nsamples=`echo $samples_block | grep -oP "\d+\s+samples" | grep -oP "\d+"`

npages=$((($nsamples + 4999) / 5000))


mkdir parts
seq $npages | xargs -I {} -n 1 wget 'https://www.ncbi.nlm.nih.gov/geo/browse/?view=samples&sort=acc&mode=tsv&page={}&display=5000' -O parts/gsm_table_p{}.tsv
head -1 parts/gsm_table_p1.tsv | cat - <(tail -q -n +2 parts/gsm_table_p*.tsv) > gsm_table.tsv
gzip gsm_table.tsv
rm -rf parts