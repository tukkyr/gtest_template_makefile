CC=/usr/local/llvm-3.2/bin/clang++
CFLAGS=-g -Wall -std=c++11 -stdlib=libc++ -DGTEST_HAS_PTHREAD=0 -DGTEST_HAS_TR1_TUPLE=0 -I/home/tukkyr/libcxx/include -L/home/tukkyr/libcxx/build/lib
FUSED_GTEST_H=gtest/gtest.h
FUSED_GTEST_ALL_CC=gtest/gtest-all.cc
GTEST_MAIN_CC=gtest/gtest_main.cc

TARGET=a.out
-include makefile.opt

SRC=$(shell ls *.cpp)
HED=$(shell ls *.h)
OBJ=$(SRC:.cpp=.o)
OBJ+=gtest-all.o gtest_main.o

.SUFFIXES: .cpp .o .h
all: $(TARGET)
$(TARGET):$(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

gtest-all.o:$(FUSED_GTEST_H) $(FUSED_GTEST_ALL_CC)
	$(CC) $(CFLAGS) -c gtest/gtest-all.cc

gtest_main.o:$(FUSED_GTEST_H) $(GTEST_MAIN_CC)
	$(CC) $(CFLAGS) -c gtest/gtest_main.cc

.cpp.o:
	$(CC) $(CFLAGS) -o $@ -c $^

.PHONY : run
run:
	./a.out

.PHONY : clean 
clean:
	rm -f $(TARGET).exe $(TARGET)
	ls | grep -v -E "gtest.*" | grep -E ".*\.o" | xargs rm -r 

.PHONY : dep
dep:
	g++ -MM -MG $(SRC) > makefile.depend

.PHONY : tar
tar:
	tar cvzf $(TARGET).tar.gz $(SRC) $(HED) makefile

-include makefile.depend
