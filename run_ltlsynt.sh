filename=$(basename -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"
LTL=$(syfco $1 -f ltlxba -m fully)
IN=$(syfco $1 --print-input-signals)
OUT=$(syfco $1 --print-output-signals)
ltlsynt --formula="$LTL" --ins="$IN" --outs="$OUT" > $filename.hao
./parsedot $filename.hao
sed -i 1d parsed_$filename.hao
autfilt parsed_$filename.hao --deterministic --dot > $filename.dot
sed -i 's/|/|\\n/g' $filename.dot
dot -Tpng $filename.dot -o $filename.png
