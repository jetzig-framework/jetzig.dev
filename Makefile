.PHONY: publish
publish:
	@bash render.bash
	@rsync --delete -r out/ docs.bob.frl:/var/www/jetzig/html/
	@echo 'Published.'
