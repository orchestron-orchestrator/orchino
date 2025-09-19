.PHONY: $(addprefix platform-wait-,$(ROUTERS_XR) $(ROUTERS_CRPD) $(ROUTERS_SRL))

$(addprefix platform-wait-,$(ROUTERS_XR)):
# Wait for "smartlicserver[212]: %LICENSE-SMART_LIC-3-COMM_FAILED : Communications failure with the Cisco Smart License Utility (CSLU) : Unable to resolve server hostname/domain name" to appear in the container logs
	timeout --foreground $(WAIT) bash -c "until docker logs $(TESTENV)-$(@:platform-wait-%=%) 2>&1 | grep -q 'smartlicserver'; do sleep 1; done"
	docker run $(INTERACTIVE) --rm --network container:$(TESTENV)-otron ghcr.io/notconf/notconf:debug netconf-console2 --host $(@:platform-wait-%=%) --port 830 --user clab --pass clab@123 --hello

.PHONY: cli $(addprefix platform-cli-,$(ROUTERS_XR))

$(addprefix platform-cli-,$(ROUTERS_XR)):
	docker exec -it $(TESTENV)-$(subst platform-cli-,,$@) /pkg/bin/xr_cli.sh
