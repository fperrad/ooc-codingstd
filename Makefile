

TESTS:= LineLength.ooc HardTabs.ooc TrailingSpace.ooc

all:
	prove --exec="rock -r -sourcepath=../ooc-codingstd/source" $(TESTS)

clean:
	rm -rf *_tmp/ .libs/
	rm LineLength HardTabs TrailingSpace
