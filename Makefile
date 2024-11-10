.PHONY: deploy
deploy:
	@jetzig -e production bundle --arch x86_64
	@scp bundle.tar.gz docs.bob.frl:
	@ssh docs.bob.frl 'tar zxf bundle.tar.gz'
	@ssh docs.bob.frl 'killall server || :'
	@ssh docs.bob.frl '. jetzig.env ; cd jetzig.dev ; ./server --detach --log /var/log/jetzig.dev.log --bind 0.0.0.0 --port 8080'
	@echo 'Published.'
