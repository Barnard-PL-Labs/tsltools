for file in test/res/specs/*
do
  ./tslsynth "$file" --js --write-hoa "$file".hoa
done
