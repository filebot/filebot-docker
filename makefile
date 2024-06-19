filebot:
	docker build --rm -t filebot -f Dockerfile .
	docker run -it -v ${PWD}:/volume1 -v data:/data filebot -script fn:sysinfo

filebot-node:
	docker build --rm -t filebot-node -f Dockerfile.node .
	docker run -it -v ${PWD}:/volume1 -v data:/data -p 5452:5452 filebot-node

filebot-watcher:
	docker build --rm -t filebot-watcher -f Dockerfile.watcher .
	mkdir -p input output
	docker run -it -v ${PWD}:/volume1 -v data:/data -e SETTLE_DOWN_TIME=5 filebot-watcher /volume1/input --output /volume1/output

filebot-xpra:
	docker build --rm -t filebot-xpra -f Dockerfile.xpra .
	docker run -it -v ${PWD}:/volume1 -v data:/data -p 5454:5454 filebot-xpra

filebot-projector:
	docker build --rm -t filebot-projector -f Dockerfile.projector .
	docker run -it -v data:/data -p 8887:8887 filebot-projector

filebot-webdav:
	docker build --rm -t filebot-webdav -f Dockerfile.webdav .
	docker run -it -v ${PWD}:/volume1 -v data:/data -e USERNAME=alice -e PASSWORD=secret1234 -p 8080:8080 filebot-webdav

filebot-alpine:
	docker build --rm -t filebot-alpine -f Dockerfile.alpine .
	docker run -it -v ${PWD}:/volume1 -v data:/data filebot-alpine -script fn:sysinfo

filebot-graalvm:
	docker build --rm -t filebot-graalvm -f Dockerfile.graalvm .
	docker run -it -v ${PWD}:/volume1 -v data:/data filebot-graalvm -script fn:sysinfo

filebot-beta:
	docker build --rm -t filebot-beta -f Dockerfile.beta .
	docker run -it -v ${PWD}:/volume1 -v data:/data filebot-beta -script fn:sysinfo

filebot-shell:
	docker build --rm -t filebot -f Dockerfile .
	docker run -it -v ${PWD}:/volume1 -v data:/data --entrypoint /bin/bash filebot

clean:
	git reset --hard
	git pull
	git --no-pager log -1
