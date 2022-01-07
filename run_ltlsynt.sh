filename=$(basename -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"
LTL=$(syfco $1 -f ltlxba -m fully)
IN=$(syfco $1 --print-input-signals)
OUT=$(syfco $1 --print-output-signals)
ltlsynt --dot --formula="$LTL" --ins="$IN" --outs="$OUT" > $filename.dot
sed -i 1d $filename.dot
dot -Tpng $filename.dot -o $filename.png
