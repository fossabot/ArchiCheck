.SILENT:

## mkfile := $(abspath $(lastword $(MAKEFILE_LIST)))
## rootdir := $(dir $(patsubst %/,%,$(dir $(mkfile))))

all: clean build check doc

release: build_release 
	echo Make release build

	> docs/download.md
	echo "Download"			 										>> docs/download.md
	echo "========"			 										>> docs/download.md
	echo "" 														>> docs/download.md
	echo "[Here](http://lionel.draghi.free.fr/Archicheck/archicheck) is an exe build on my Debian amd64,"	>> docs/download.md
	echo "with -O3 option." 										>> docs/download.md
	echo 	 														>> docs/download.md
	echo "Build :" 													>> docs/download.md
	echo "-------" 													>> docs/download.md
	echo 	 														>> docs/download.md
	echo "> date -r archicheck --iso-8601=seconds" 					>> docs/download.md
	echo 	 														>> docs/download.md
	echo '```' 														>> docs/download.md
	date -r Linux_amd64_release/archicheck --iso-8601=seconds 		>> docs/download.md
	echo '```' 														>> docs/download.md
	echo 	 														>> docs/download.md
	echo "> archicheck --version"				 					>> docs/download.md
	echo 	 														>> docs/download.md
	echo '```' 														>> docs/download.md
	./Linux_amd64_release/archicheck --version				 		>> docs/download.md
	echo '```' 														>> docs/download.md
	echo 	 														>> docs/download.md
	echo "Dependencies :" 											>> docs/download.md
	echo "--------------" 											>> docs/download.md
	echo 	 														>> docs/download.md
	echo "> readelf -d archicheck | grep 'NEEDED'" 					>> docs/download.md
	echo 	 														>> docs/download.md
	echo '```' 														>> docs/download.md
	readelf -d Linux_amd64_release/archicheck | grep 'NEEDED'		>> docs/download.md
	echo '```' 														>> docs/download.md
	echo 	 														>> docs/download.md
	echo "Tests :"		 											>> docs/download.md
	echo "-------" 													>> docs/download.md
	echo 	 														>> docs/download.md
	cat release_tests.txt											>> docs/download.md
	
	cp -rp Obj/archicheck Linux_amd64_release/
	cp -rp Linux_amd64_release/archicheck site/
	rm release_tests.txt

build: 
	echo Make debug build

	gprbuild -q -P patched_ot
	gnat make -q -s -Xmode=debug -Parchicheck.gpr
	# -q : quiet
	# -s : recompile if compiler switches have changed

.PHONY : build_release
build_release:
	gprbuild -q -P patched_ot
	gnat make -q -s -Xmode=release -Parchicheck.gpr
	# -q : quiet
	# -s : recompile if compiler switches have changed

	# equal to check, but without coverage :
	echo - Running tests :
	$(MAKE) --ignore-errors --directory=Tests

	echo "Run "`date --iso-8601=seconds` 	>  release_tests.txt
	echo									>> release_tests.txt
	sed "s/^/- /" Tests/tests_count.txt		>> release_tests.txt

	echo
	echo - Tests summary :
	cat Tests/tests_count.txt


check: Obj/archicheck
	# depend on the exe, may be either build or build_release, test have to pass with both
	echo Make check

	echo - Initializing coverage data before run
	lcov --quiet --capture --initial --directory Obj -o Obj/coverage.info
	# lcov error are ignored because this is also runned when in release mode, without 
	# coverage info generated

	echo - Running tests :
	$(MAKE) --ignore-errors --directory=Tests

	echo
	echo - Tests summary :
	cat Tests/tests_count.txt

	echo
	echo - Capturing coverage data
	lcov --quiet --capture --directory Obj -o Obj/coverage.info


dashboard: Obj/coverage.info Tests/tests_count.txt
	echo Make dashboard

	@ # Language pie
	@ # --------------------------------------------------------------------
	sloccount Src Tests/Tools | grep "ada=" |  ploticus  -prefab pie 	\
		data=stdin labels=2 colors="blue red green orange"		\
		explode=0.1 values=1 title="Ada sloc `date +%x`"		\
		-png -o docs/sloc.png

	@ # Code coverage Pie
	@ # --------------------------------------------------------------------
	lcov -q --remove Obj/coverage.info -o Obj/coverage.info \
		"/usr/*" "*.ads" "*/Obj/b__archicheck-main.adb"
	# Ignoring :
	@ # - spec (results are not consistent with current gcc version) 
	@ # - the false main
	@ # - libs (Standart and OpenToken) 

	@ # --------------------------------------------------------------------
	genhtml Obj/coverage.info -o site/lcov -t "ArchiCheck tests coverage" \
		-p "/home/lionel/Proj/Archichek" | tail -n 2 > cov_sum.txt
	
	# Processing the lines line :
	@ # --------------------------------------------------------------------
	# > lines_cov.dat
	# head -n 1 cov_sum.txt | sed "s/.*(/\"Covered lines\" /" | sed "s/ of .*//"		>> lines_cov.dat
	# head -n 1 cov_sum.txt | sed "s/.* of /\"Total   lines\" /" | sed "s/ lines)//"	>> lines_cov.dat
	# ploticus -prefab pie 						\
	# 	data=lines_cov.dat labels=1 colors="green blue" 	\
	# 	explode=0.1 values=2 title="Lines coverage `date +%x`"	\
	# 	labelfmtstring=@2 -png -o docs/lines_coverage.png
	
	# Processing the functions line :
	@ # --------------------------------------------------------------------
	# > functions_cov.dat
	# tail -n 1 cov_sum.txt | sed "s/.*(/\"Covered functions\" /" | sed "s/ of .*//"			>> functions_cov.dat
	# tail -n 1 cov_sum.txt | sed "s/.* of /\"Total   functions\" /" | sed "s/ functions)//"	>> functions_cov.dat
	# ploticus -prefab pie data=functions_cov.dat labels=1 colors="green blue" 	\
	# 	explode=0.1 values=2 title="Functions coverage `date +%x`"		\
	# 	labelfmtstring=" @2\\n (@PCT%)" -png -o docs/functions_coverage.png
	
	@ # Test pie	
	@ # --------------------------------------------------------------------
	ploticus -prefab pie legend=yes							\
		data=Tests/tests_count.txt labels=1 colors="green red orange"	\
		explode=0.1 values=2 title="Tests results `date +%x`"			\
		-png -o docs/tests.png

	>  docs/dashboard.md
	echo "Dashboard"				>> docs/dashboard.md
	echo "========="				>> docs/dashboard.md
	echo 							>> docs/dashboard.md
	echo "Test results"				>> docs/dashboard.md
	echo "------------"				>> docs/dashboard.md
	echo '```'			 			>> docs/dashboard.md
	cat Tests/tests_count.txt		>> docs/dashboard.md
	echo '```'			 			>> docs/dashboard.md
	echo "![](tests.png)"			>> docs/dashboard.md
	echo 							>> docs/dashboard.md
	echo "Coverage"					>> docs/dashboard.md
	echo "--------"					>> docs/dashboard.md
	echo 							>> docs/dashboard.md
	echo '- Lines coverage rate'	>> docs/dashboard.md
	echo '```'			 			>> docs/dashboard.md
	head -n 1 cov_sum.txt			>> docs/dashboard.md
	echo '```'			 			>> docs/dashboard.md
	# echo "![](img/lines_coverage.png)"		>> docs/dashboard.md
	echo 							>> docs/dashboard.md
	echo '- Function coverage rate'	>> docs/dashboard.md
	echo '```'			 			>> docs/dashboard.md
	tail -n 1 cov_sum.txt			>> docs/dashboard.md
	echo '```'			 			>> docs/dashboard.md
	# echo "![](img/functions_coverage.png)"	>> docs/dashboard.md
	echo 							>> docs/dashboard.md
	echo '- Coverage in the sources'	>> docs/dashboard.md
	echo '  [lcov generated](http://lionel.draghi.free.fr/Archicheck/lcov/index.html)'		>> docs/dashboard.md

cmd_line.md:
	echo Make cmd_line.md
	> docs/cmd_line.md
	echo "Archicheck command line"		>> docs/cmd_line.md
	echo "======================="		>> docs/cmd_line.md
	echo ""								>> docs/cmd_line.md
	echo "Archicheck command line"		>> docs/cmd_line.md
	echo "-----------------------"		>> docs/cmd_line.md
	echo ""								>> docs/cmd_line.md
	echo '```'							>> docs/cmd_line.md
	echo "$ archicheck -h" 				>> docs/cmd_line.md
	echo '```'							>> docs/cmd_line.md
	echo ""								>> docs/cmd_line.md
	echo '```'							>> docs/cmd_line.md
	Obj/archicheck -h 					>> docs/cmd_line.md
	echo '```'							>> docs/cmd_line.md
	echo ""								>> docs/cmd_line.md
	echo "Archicheck current version"	>> docs/cmd_line.md
	echo "--------------------------"	>> docs/cmd_line.md
	echo ""								>> docs/cmd_line.md
	echo '```'							>> docs/cmd_line.md
	echo "$ archicheck --version"		>> docs/cmd_line.md
	echo '```'							>> docs/cmd_line.md
	echo ""								>> docs/cmd_line.md
	echo '```'							>> docs/cmd_line.md
	Obj/archicheck --version			>> docs/cmd_line.md
	echo '```'							>> docs/cmd_line.md
	echo ""								>> docs/cmd_line.md

doc: dashboard cmd_line.md
	echo Make Doc
    
	mkdocs build 
    
.PHONY : clean
clean:
	echo Make clean
	gnat clean -q -Parchicheck.gpr
	- ${RM} -rf Obj/* site/lcov/* tmp.txt *.lst *.dat cov_sum.txt site/* 
	$(MAKE) --directory=Tests clean
	gnat clean -q -P patched_ot
    
    
