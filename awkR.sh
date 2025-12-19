#!/bin/bash

for memb in Ftn0 Ftn10 Ftn20 Ftn30
for i in {1..37}; do
    echo "Processing File $memb/u$i/u$i_pullx.xvg"
    awk 'NR>100017 {print}' "$memb/u$i/u$i"_pullx.xvg > "$memb/u$i"_pullx.xvg
done
done

