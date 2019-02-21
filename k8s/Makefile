.PHONY: configmap

configmap:
	-kubectl delete secret osg-wn-prp-sdsc-config -n osggpus
	-kubectl delete secret osg-collector-sdsc-config -n osg
	kubectl create secret generic osg-wn-prp-sdsc-config -n osggpus --from-file=pool_password \
             --from-file=50_condor_host.config=wn-gpu.d/50_condor_host.config --from-file=02_memory_limits.config=wn-gpu.d/02_memory_limits.config \
             --from-file=30_gpu.config=wn-gpu.d/30_gpu.config 
	kubectl create secret generic osg-collector-sdsc-config -n osg --from-file=pool_password
