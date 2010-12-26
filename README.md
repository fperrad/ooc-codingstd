
ooc-CodingStd
=============

a set of coding standard tests written in ooc for project using ooc.

Why Coding Standard
-------------------

Coding Standard is about consistency.

The goal is to improve collaboration and maintainance.

How Use Them in Your Project
----------------------------

Pre-requisites:

+ your project must use GIT
+ a recent perl (>= 5.10.1) or at least a recent Test::Harness module (>= 3.17) (run `prove -V`)

add in your Makefile :

    # your own selection of tests
    CODING_STD = \
      TrailingSpace \
      HardTabs \
      LineLength \
      ...

    codingstd: ../ooc-codingstd
            prove --exec="rock -r -sourcepath=../ooc-codingstd/source" $(CODING_STD)

    ../ooc-codingstd:
            cd .. && git clone git://github.com/fperrad/ooc-codingstd.git

now, you could run :

    $ make codingstd
