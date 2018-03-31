all: docs script

docs: README

org/all_files.org: org/00_intro.org org/01_create_site.org org/99_outtro.org
	cat org/00_intro.org org/01_create_site.org org/99_outtro.org > org/all_files.org

script: _out org/all_files.org
	emacs -q --batch --file org/all_files.org --eval "(org-babel-tangle)"
	chmod +x _out/nopanel.sh

_out: 
	mkdir -p _out
clean:
	rm -f org/all_files.org
	rm -f _out/*
	rm -f README
README:
	emacs -q --batch --file org/all_files.org --eval "(org-ascii-export-to-ascii)"
	mv org/all_files.txt README

