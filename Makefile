.PHONY: create clean provision

check-%:
	@ if [ "${${*}}" = "" ]; then \
	    echo "Environment variable $* not set"; \
	    exit 1; \
	fi

create: check-IMAGE_NAME check-KERNEL check-OS_VERSION check-PUBLISH_URL
	@ vagrant up

provision: check-IMAGE_NAME check-KERNEL check-OS_VERSION check-PUBLISH_URL
	@ vagrant provision

clean:
	$(RM) core-* done *.deb shasum256.txt
	@ vagrant destroy -f
