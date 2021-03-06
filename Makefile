.PHONY: test
current_dir = $(shell pwd)
rmnpath = "/Users/drew/work/rmn"
echo:
	echo $(current_dir)

install:
	go install github.com/drewwells/sprite_sass/sprite
home:
	go run sprite/main.go -gen ~/work/rmn/www/gui/build/im -b ~/work/rmn/www/gui/build/css/ -p ~/work/rmn/www/gui/sass -d ~/work/rmn/www/gui/im/sass ~/work/rmn/www/gui/sass/_pages/home.scss
profile: install
	sprite --cpuprofile=sprite.prof -gen ~/work/rmn/www/gui/build/im -b ~/work/rmn/www/gui/build/css/ -p ~/work/rmn/www/gui/sass -d ~/work/rmn/www/gui/im/sass ~/work/rmn/www/gui/**/*.scss
	go tool pprof --png $(GOPATH)/bin/sprite sprite.prof > profile.png
	open profile.png
deps:
	scripts/getdeps.sh
headers:
	scripts/getheaders.sh
build:
	docker build -t sprite .
docker:
	docker run -it -v $(rmnpath):/rmn -v $(current_dir):/usr/src/myapp sprite bash
dockerprofile:
	docker run -it -v $(rmnpath):/rmn -v $(current_dir):/usr/src/myapp sprite make dockerexec
dockerexec:
	go run sprite/main.go -gen /rmn/www/gui/build/im  --cpuprofile=sprite.prof -b /rmn/www/gui/build/css/ -p /rmn/www/gui/sass -d /rmn/www/gui/im/sass /rmn/www/gui/**/*.scss
	go tool pprof --pdf /usr/bin/sprite sprite.prof > profile.pdf
test:
	scripts/goclean.sh
compass:
	cd ~/work/rmn && grunt clean && time grunt build_css
swift: install
	time sprite -gen ~/work/rmn/www/gui/build/im -b ~/work/rmn/www/gui/build/css/ -p ~/work/rmn/www/gui/sass -d ~/work/rmn/www/gui/im/sass ~/work/rmn/www/gui/**/*.scss
time: compass swift
