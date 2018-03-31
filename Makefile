all: docs script

docs: README

script: _out/nopanel.sh

bundle.org: $(wildcard org/*.org)
	cat org/*.org > bundle.org

_out/nopanel.sh: _out bundle.org
	emacs -q --batch --file bundle.org --eval "(org-babel-tangle)"
	chmod +x _out/nopanel.sh

_out: 
	mkdir -p _out
clean:
	rm -f bundle.org
	rm -f _out/*
	rm -f README

README: bundle.org
	emacs -q --batch --file bundle.org --eval "(org-ascii-export-to-ascii)"
	mv bundle.txt README

