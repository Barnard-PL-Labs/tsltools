#!/usr/bin/env bash
strix="../Strix/scripts/strix_tlsf.sh"
cat > file.tlsf
$strix file.tlsf > temp.tmp
head -n 1 temp.tmp
