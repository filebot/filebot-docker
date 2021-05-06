docker:
	docker build --rm -t filebot -f Dockerfile .
	docker run -i -v ${PWD}:/volume1 -v data:/data filebot -script fn:sysinfo

docker-alpine:
	docker build --rm -t filebot-alpine -f Dockerfile.alpine .
	docker run -i -v ${PWD}:/volume1 -v data:/data filebot-alpine -script fn:sysinfo

docker-graalvm:
	docker build --rm -t filebot-graalvm -f Dockerfile.graalvm .
	docker run -i -v ${PWD}:/volume1 -v data:/data filebot-graalvm -script fn:sysinfo

docker-node:
	docker build --rm -t filebot-node -f Dockerfile.node .
	docker run -i -v ${PWD}:/volume1 -v data:/data -p 5452:5452 filebot-node

docker-watcher:
	docker build --rm -t filebot-watcher -f Dockerfile.watcher .
	mkdir -p input output
	docker run -i -v ${PWD}:/volume1 -v data:/data filebot-watcher /volume1/input --output /volume1/output

clean:
	git reset --hard
	git pull
	git --no-pager log -1
