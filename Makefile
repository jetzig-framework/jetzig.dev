.PHONY: deploy
deploy:
	@zig build -Doptimize=Debug install
	@scp zig-out/bin/jetzig.dev.zig docs.bob.frl:
	@rsync -r public/ docs.bob.frl:public/
	@echo 'Published.'
