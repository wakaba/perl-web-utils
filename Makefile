PROVE = prove
P2H = local/p2h
CURL = curl

all: \
	lib/URL/PercentEncode.html

%.html: %.pod $(P2H)
	$(P2H) "perl-web-utils" $< > $@

$(P2H): local
	$(CURL) -sSfL https://raw.githubusercontent.com/manakai/manakai.github.io/master/p2h > $@
	chmod u+x $@

local:
	mkdir -p local

test:
	$(PROVE) t/url

## License: Public Domain.
