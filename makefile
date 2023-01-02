docker:
	docker build --rm -t filebot -f Dockerfile .
	docker run -e PUID=1000 -e PGID=100 -it -v ${PWD}:/volume1 -v data:/data filebot -script fn:sysinfo

docker-alpine:
	docker build --rm -t filebot-alpine -f Dockerfile.alpine .
	docker run -it -v ${PWD}:/volume1 -v data:/data filebot-alpine -script fn:sysinfo

docker-graalvm:
	docker build --rm -t filebot-graalvm -f Dockerfile.graalvm .
	docker run -it -v ${PWD}:/volume1 -v data:/data filebot-graalvm -script fn:sysinfo

docker-node:
	docker build --rm -t filebot-node -f Dockerfile.node .
	docker run -it -v ${PWD}:/volume1 -v data:/data -p 5452:5452 filebot-node

docker-watcher:
	docker build --rm -t filebot-watcher -f Dockerfile.watcher .
	mkdir -p input output
	docker run -it -v ${PWD}:/volume1 -v data:/data -e SETTLE_DOWN_TIME=5 filebot-watcher /volume1/input --output /volume1/output

docker-xpra:
	docker build --rm -t filebot-xpra -f Dockerfile.xpra .
	docker run -it -v ${PWD}:/volume1 -v data:/data -p 5454:5454 filebot-xpra

docker-shell:
	docker build --rm -t filebot -f Dockerfile .
	docker run -e PUID=1000 -e PGID=100 -it -v ${PWD}:/volume1 -v data:/data --entrypoint /bin/bash filebot

clean:
	git reset --hard
	git pull
	git --no-pager log -1
