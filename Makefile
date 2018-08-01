all: volume run ## Default cmd

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

pull: ## Pull image from repo
	@docker pull microsoft/mssql-server-linux:2017-latest

volume: ## Create persistent volume
	@docker create -v /var/opt/mssql --name mssql-volume \
		microsoft/mssql-server-linux \
		/bin/true

run: ## Create and run container
	@docker run \
		-e 'ACCEPT_EULA=Y' \
		-e 'SA_PASSWORD=Dthcnf07@' \
		-p 1433:1433 \
		--volumes-from mssql-volume \
		-d \
		--name mssql-container \
		microsoft/mssql-server-linux

stop: ## Stop container
	@docker stop mssql-container

clean: stop ## Remove container and volume
	@docker rm mssql-volume mssql-container

prune: ## Prune docker system
	@docker system prune -f --volumes
