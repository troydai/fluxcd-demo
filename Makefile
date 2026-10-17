.PHONY: cluster-up cluster-down bootstrap

cluster-up:
	./bin/cluster.sh up

cluster-down:
	./bin/cluster.sh down

bootstrap:
	./bin/bootstrap.sh
