install:
	stack install

test:
	stack test

doc:
	stack haddock --open

format:
	ormolu --mode inplace $$(find . -name '*.hs')

clean:
	stack clean

.PHONY: install test doc format clean
.SILENT:
