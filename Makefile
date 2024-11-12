.PHONY: deploy
deploy:
	@npx tailwind --output public/styles.css
	@jetzig -e production bundle --arch x86_64
	@scp bundle.tar.gz www.jetzig.dev:
	@ssh www.jetzig.dev 'tar zxf bundle.tar.gz'
	@ssh www.jetzig.dev 'killall server || :'
	@ssh www.jetzig.dev '. jetzig.env ; cd jetzig.dev ; ./server --detach --log /var/log/jetzig.dev.log --log-format json --bind 0.0.0.0 --port 8080 &'
	@echo 'Published.'
