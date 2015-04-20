GULP_APPS=sharing directory customizer webmaker-app
GRUNT_APPS=loop
NO_BUILD_APPS=studio buddyup

build_gulp_app=(cd apps/$(app) && \
	npm install && \
	(([ -f bower.json ] && bower $(BOWER_FLAGS) install && bower $(BOWER_FLAGS) update) || true) && \
	(([ "$(app)" = "sharing" ] && npm run apm) || true) && \
	gulp build && \
	(([ -f custombuild ] && ./custombuild) || true)) && \
	rm -rf gaia/outoftree_apps/$(app) && \
	mkdir -p gaia/outoftree_apps/$(app)/ && \
	(([ -d apps/$(app)/dist/app ] && cp -r apps/$(app)/dist/app/* gaia/outoftree_apps/$(app)/) || \
	 ([ -d apps/$(app)/build ] && cp -r apps/$(app)/build/* gaia/outoftree_apps/$(app)/)) &&

build_grunt_app=(cd apps/$(app) && \
	npm install && grunt releaseProduction --force) && \
	rm -rf gaia/outoftree_apps/$(app) && \
	cp -r apps/$(app)/build gaia/outoftree_apps/$(app) &&

clean_gulp_app=(cd apps/$(app); gulp clean; rm -rf node_modules; rm -rf app/components/); \
	$(simple_clean_app)

clean_grunt_app=(cd apps/$(app); rm -rf node_modules; rm -rf build); \
	$(simple_clean_app)

simple_clean_app=rm -rf gaia/outoftree_apps/$(app);

build=rm -f apps/studio/.git/shallow && \
	$(copy_assets) && \
	mkdir -p gaia/outoftree_apps/ && \
	$(foreach app, $(GULP_APPS), $(build_gulp_app)) \
	$(foreach app, $(GRUNT_APPS), $(build_grunt_app)) \
	$(foreach app, $(NO_BUILD_APPS), $(copy_app)) \
	$(copy_external_apps)

copy_assets=cp default-homescreens.json gaia/apps/verticalhome/build/ && \
						cp wallpaper@2.25x.jpg gaia/build/config/

# Copies apps that we download and preload directly from Marketplace.
copy_external_apps=find preload-app-toolkit/ -type d -maxdepth 1 \
	-not -name "views" -not -name ".git" -not -path "preload-app-toolkit/" \
	-exec cp -rp {} gaia/outoftree_apps/ \;

copy_app=rm -rf gaia/outoftree_apps/$(app) && \
	(([ -d apps/$(app)/app ] && \
		cp -r apps/$(app)/app gaia/outoftree_apps/$(app)) || \
		cp -r apps/$(app) gaia/outoftree_apps/) &&

hellomake:
	$(build) && (cd gaia && make)

shallow:
	$(build)

install-gaia:
	$(build) && (cd gaia && make install-gaia)

reset-gaia:
	$(build) && (cd gaia && make reset-gaia)

sync:
	./repo sync && ./get-external-apps.sh

install:
	./repo init -u https://github.com/fxos/lightsaber.git

clean:
	$(foreach app, $(GULP_APPS), $(clean_gulp_app)) \
	$(foreach app, $(GRUNT_APPS), $(clean_grunt_app)) \
	$(foreach app, $(NO_BUILD_APPS), $(simple_clean_app)) \
	(cd gaia && make clean)

really-clean:
	rm -rf .repo gaia apps
