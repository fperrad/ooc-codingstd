

TESTS:= \
  LineLength \
  HardTabs \
  TrailingSpace \
  CuddledElse

all:
	prove --exec="rock -r -sourcepath=../ooc-codingstd/source" $(TESTS)

clean:
	rm -rf *_tmp/ .libs/
	rm -f $(TESTS)
