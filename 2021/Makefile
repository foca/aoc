FILES := $(wildcard *.cr */*.cr)
BINS := $(foreach f,$(FILES),$(dir $(f))bin/$(notdir $(basename $(f))))

all: $(BINS)

clean:
	rm -f $(BINS)
	find . -name '*.dwarf' -exec rm \{\} \;

# used when running make from the puzzle directory
bin/%: %.cr
	crystal build -o $@ $<

# used when running make from the year directory
*/bin/%: */%.cr
	crystal build -o $@ $<

.PHONY: all clean
