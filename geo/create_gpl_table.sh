#!/bin/bash

content=`wget -qO - "https://www.ncbi.nlm.nih.gov/geo/browse/?view=platforms&sort=acc&page={}&display=500"`

platforms_block=`echo $content | grep -oP "<div id=\"count\" class=\"commas\">.*?</div>"`
nplatforms=`echo $platforms_block | grep -oP "\d+\s+platforms" | grep -oP "\d+"`

npages=$((($nplatforms + 4999) / 5000))


mkdir parts
seq $npages | xargs -I {} -n 1 wget 'https://www.ncbi.nlm.nih.gov/geo/browse/?view=platforms&sort=acc&mode=tsv&page={}&display=5000' -O parts/gpl_table_p{}.tsv
head -1 parts/gpl_table_p1.tsv | cat - <(tail -q -n +2 parts/gpl_table_p*.tsv) > gpl_table.tsv
gzip gpl_table.tsv
rm -rf parts