hellomake:
	(cd sharing && npm install && bower install && npm run apm && gulp build) && \
	mkdir -p gaia/outoftree_apps/ && \
	ln -s ../../sharing/dist/app gaia/outoftree_apps/sharing && \
	(cd gaia && make install-gaia)

clean:
	(cd sharing && gulp clean) || \
	rm -rf gaia/outoftree_apps/ || \
	(cd gaia && make clean)
