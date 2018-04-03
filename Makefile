BUILDDIR = build
BUILD_COMMAND = sphinx-build -a -W
BUILD_COMMAND_AND_ARGS = $(BUILD_COMMAND)

docs:
	mkdir -p $(BUILDDIR)
	cp -r misc/robots.txt build/
	cp -r misc/sitemap.xml build/
	$(BUILD_COMMAND_AND_ARGS) chef_master/source $(BUILDDIR)
	bash doctools/rundtags.sh

clean:
	@rm -rf $(BUILDDIR)

setup-environment:
	brew install pyenv
	brew install pyenv-virtualenv
	CFLAGS="-I$(shell xcrun --show-sdk-path)/usr/include" pyenv install
	pyenv virtualenv chef-web-docs
	pyenv rehash

destroy-environment:
	pyenv virtualenv-delete -f chef-web-docs
	pyenv uninstall -f 2.7.14
	pyenv rehash

docker-build:
	docker build . -t docsbuild
	docker run -v $(shell pwd):/build_dir -it docsbuild:latest