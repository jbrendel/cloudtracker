SHELL := /bin/bash

SUPPORTED_VERSIONS=1 6
DEV_TARGETS = $(addprefix dev_elasticsearchv,${SUPPORTED_VERSIONS})

.PHONY: requirements_es1
requirements_es1: requirements.txt requirements-dev.txt
	@sed -e 's/^elasticsearch==\(.*$$\)/elasticsearch==1.9.0/g' requirements.txt | sed -e 's/^elasticsearch_dsl==\(.*$$\)/elasticsearch_dsl==0.0.11/g' > requirements.es1.txt
	@sed -e 's/requirements\.txt/requirements.es1.txt/g' requirements-dev.txt > requirements-dev.es1.txt

.PHONY: requirements_es6
requirements_es6: requirements.txt requirements-dev.txt
	@cp requirements.txt requirements.es6.txt
	@cp requirements-dev.txt requirements-dev.es6.txt

.PHONY: ${DEV_TARGETS}
${DEV_TARGETS}: dev_elasticsearchv%: requirements_es%
	@( \
		test -d ./venv || virtualenv ./venv; \
		. ./venv/bin/activate; \
		pip install --upgrade pip; \
		pip install -r requirements-dev.es$*.txt; \
	)
	@echo
	@echo "** You have configured your environment for elasticsearch v$* **"
	@echo '** Now you should `source ./venv/bin/activate` to activate your virtualenv **'
	@echo

.PHONY: clean
clean:
	@rm -rf ./venv
	@ls -1 | grep -P "requirements(-)?(dev)?\.es\d\.txt" | xargs
