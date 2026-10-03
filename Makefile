all: index.html

neuropro.js: ../brainlight/dist/lib/neuropro/index.js
	$(MAKE) -C ../brainlight dist
	cp ../brainlight/dist/lib/neuropro/index.js neuropro.js.new
	cp ../brainlight/dist/lib/neuropro/index.js.map neuropro.js.map.new
	cp ../brainlight/dist/lib/neuropro/index.d.ts neuropro.d.ts.new
	cp ../brainlight/dist/lib/neuropro/index.d.ts.map neuropro.d.ts.map.new
	echo '' >> neuropro.js.new
	mv neuropro.js.new neuropro.js
	mv neuropro.js.map.new neuropro.js.map
	mv neuropro.d.ts.new neuropro.d.ts
	mv neuropro.d.ts.map.new neuropro.d.ts.map

neuropro.d.ts: neuropro.js
neuropro.js.map: neuropro.js
neuropro.d.ts.map: neuropro.js

index.html: neuropro.js neuropro.d.ts neuropro.js.map neuropro.d.ts.map index.base.html index.device.html Makefile
	sed \
	  -e '/__DEVICE_HTML__/r index.device.html' \
	  -e '/__NEUROPRO_JS__/r neuropro.js' \
	index.base.html | sed \
	    -e '/__[A-Z_]*__/d' \
	    -e '/^#!/d' \
	    -e '/^\/\/# sourceMappingURL/d' \
	    -e 's/^export //' \
	> index.html.new
	mv index.html.new index.html

clean:
	rm -f neuropro.js neuropro.js.map neuropro.d.ts neuropro.d.ts.map
	rm -f neuropro.js.new neuropro.js.map.new neuropro.d.ts.new neuropro.d.ts.map.new
	rm -f index.html.new index.html

distclean: clean

.PHONY: all clean distclean
