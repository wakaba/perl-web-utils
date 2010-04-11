PROVE = prove
POD2HTML = pod2html

all: \
	lib/URL/PercentEncode.html

%.html: %.pod
	$(POD2HTML) $< > $@

test:
	$(PROVE) t/url

## License: Public Domain.
