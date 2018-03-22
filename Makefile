all:
	emacs -q --batch --file README.org --eval "(org-babel-tangle)"
