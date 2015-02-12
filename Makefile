hellomake:
	(cd sharing && npm install && bower install) && mkdir gaia/apps/sharing/ && cp -r sharing/dist/app/* gaia/apps/sharing/
