APPS=sharing directory customizer

build_app=(cd apps/$(app) && \
	(([ -d app/fm/locales ] && cp -r app/fm/locales app/) || true) && \
	npm install && bower install && \
	(([ "$(app)" = "sharing" ] && npm run apm) || true) && \
	gulp build && \
	(([ -f custombuild ] && ./custombuild) || true)) && \
	rm -rf gaia/outoftree_apps/$(app) && \
	mkdir -p gaia/outoftree_apps/$(app)/ && \
	cp -r apps/$(app)/dist/app/* gaia/outoftree_apps/$(app)/ &&
clean_app=(cd apps/$(app); gulp clean; rm -rf node_modules; rm -rf app/components/); \
				 	rm -rf gaia/outoftree_apps/$(app);
build=rm -f apps/studio/.git/shallow && \
	mkdir -p gaia/outoftree_apps/ && \
	$(foreach app, $(APPS), $(build_app)) \
	rm -rf gaia/outoftree_apps/studio && \
	cp -r apps/studio gaia/outoftree_apps/

hellomake:
	$(build) && (cd gaia && make)

shallow:
	$(build)

install-gaia:
	$(build) && (cd gaia && make install-gaia)

reset-gaia:
	$(build) && (cd gaia && make reset-gaia)

sync:
	./repo sync

install:
	./repo init -u https://github.com/fxos/lightsaber.git

clean:
	$(foreach app, $(APPS), $(clean_app)) \
	rm -rf gaia/outoftree_apps/studio; \
	(cd gaia && make clean)

really-clean:
	rm -rf .repo gaia apps
