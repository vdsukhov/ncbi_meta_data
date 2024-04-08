#!/bin/bash
content=`wget -qO - https://www.ncbi.nlm.nih.gov/geo/browse/?view=series&sort=acc&page=1&display=500`

series_block=`echo $content | grep -oP "<div id=\"count\" class=\"commas\">.*?</div>"`
nseries=`echo $series_block | grep -oP "\d+\s+series" | grep -oP "\d+"`

npages=$((($nseries + 4999) / 5000))


mkdir parts
seq $npages | xargs -I {} -n 1 wget 'https://www.ncbi.nlm.nih.gov/geo/browse/?view=series&sort=acc&mode=tsv&page={}&display=5000' -O parts/gse_table_p{}.tsv
head -1 parts/gse_table_p1.tsv | cat - <(tail -q -n +2 parts/gse_table_p*.tsv) > gse_table.tsv
gzip gse_table.tsv
rm -rf parts