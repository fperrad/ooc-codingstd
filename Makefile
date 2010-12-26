
TESTS:= \
  LineLength \
  HardTabs \
  TrailingSpace \
  CuddledElse \
  CamelCase \
  Parentheses \

export OOC_LINE_LENGTH=120

all:
	prove --exec="rock -r -sourcepath=../ooc-codingstd/source" $(TESTS)

README.html: README.md
	Markdown.pl README.md > README.html

clean:
	rm -rf *_tmp/ .libs/
	rm -f $(TESTS)
	rm -f README.html
