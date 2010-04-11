PROVE = prove
POD2HTML = pod2html --css "http://suika.fam.cx/www/style/html/pod.css"

all: \
	lib/URL/PercentEncode.html

%.html: %.pod
	$(POD2HTML) $< > $@

test:
	$(PROVE) t/url

## License: Public Domain.
