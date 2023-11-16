build:
	stack build

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

.PHONY: build install test doc format clean
.SILENT:
