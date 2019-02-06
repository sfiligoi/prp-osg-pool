.PHONY: configmap

configmap:
	-kubectl delete secret osg-wn-prp-sdsc-config -n osggpus
	kubectl create secret generic osg-wn-prp-sdsc-config -n osggpus --from-file=pool_password \
             --from-file=50_condor_host.config=wn-gpu.d/50_condor_host.config --from-file=02_memory_limits.config=wn-gpu.d/02_memory_limits.config

