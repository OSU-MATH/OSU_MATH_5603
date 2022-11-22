.SUFFIXES:
FC=gfortran
COMPILE.f08 = $(FC) $(FCFLAGS) $(TARGET_ARCH) -c

SOURCES=hello.f95 utilities.f95

main: $(subst .f90,.o,$(SOURCES))
    $(FC) -o $@ $+

.PHONY: clean
clean:
    -rm -f *.o *.mod *.smod main
