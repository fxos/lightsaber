BUILD_APPS=sharing directory customizer
APPS=studio j2me

build_app=(cd apps/$(app) && \
	(([ -d app/fm/locales ] && cp -r app/fm/locales app/) || true) && \
	npm install && bower install && bower update && \
	(([ "$(app)" = "sharing" ] && npm run apm) || true) && \
	gulp build && \
	(([ -f custombuild ] && ./custombuild) || true)) && \
	rm -rf gaia/outoftree_apps/$(app) && \
	mkdir -p gaia/outoftree_apps/$(app)/ && \
	cp -r apps/$(app)/dist/app/* gaia/outoftree_apps/$(app)/ &&
clean_app=(cd apps/$(app); gulp clean; rm -rf node_modules; rm -rf app/components/); \
				 	$(simple_clean_app)
simple_clean_app=rm -rf gaia/outoftree_apps/$(app);
build=rm -f apps/studio/.git/shallow && \
	mkdir -p gaia/outoftree_apps/ && \
	$(foreach app, $(BUILD_APPS), $(build_app)) \
	$(foreach app, $(APPS), $(copy_app)) \
	echo ""
copy_app=rm -rf gaia/outoftree_apps/$(app) && \
	cp -r apps/$(app) gaia/outoftree_apps/ &&

hellomake:
	$(build) && (cd gaia && make)

install-gaia:
	$(build) && (cd gaia && make install-gaia)

reset-gaia:
	$(build) && (cd gaia && make reset-gaia)

sync:
	./repo sync && ./getj2me

install:
	./repo init -u https://github.com/fxos/lightsaber.git

clean:
	$(foreach app, $(BUILD_APPS), $(clean_app)) \
	$(foreach app, $(APPS), $(simple_clean_app)) \
	(cd gaia && make clean)

really-clean:
	rm -rf .repo gaia apps
