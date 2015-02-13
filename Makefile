APPS=sharing directory customizer FxOS-studio

build_app=(cd $(app) && npm install && bower install && npm run apm && gulp build) && \
	ln -s ../../sharing/dist/app gaia/outoftree_apps/$(app) &&
clean_app=(cd $(app) && gulp clean) ||

hellomake:
	mkdir -p gaia/outoftree_apps/ && \
	$(foreach app, $(APPS), $(build_app)) \
	(cd gaia && make install-gaia)

sync:
	repo sync

install:
	repo init -u https://github.com/fxos/lightsaber.git

clean:
	$(foreach app, $(APPS), $(clean_app)); \
	rm -rf gaia/outoftree_apps/; \
	(cd gaia && make clean)

really-clean:
	rm -rf .repo gaia $(APPS); \
	make clean
