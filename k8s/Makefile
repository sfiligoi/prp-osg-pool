.PHONY: secret_pool configmap configmap_base configmap_gpu configmap_opt

all: configmap

secret_pool:
	-kubectl delete secret osg-pool-sdsc-config -n osg
	kubectl create secret generic osg-pool-sdsc-config -n osg --from-file=pool_password
	-kubectl delete secret osg-pool-sdsc-config -n osggpus
	kubectl create secret generic osg-pool-sdsc-config -n osggpus --from-file=pool_password

configmap: configmap_base configmap_gpu configmap_opt

configmap_base:
	-kubectl delete configmap osg-wn-prp-config -n osggpus
	kubectl create configmap  osg-wn-prp-config -n osggpus \
             --from-file=50_condor_host.config=wn-gpu.d/50_condor_host.config --from-file=02_memory_limits.config=wn-gpu.d/02_memory_limits.config

configmap_gpu:
	-kubectl delete configmap osg-wn-prp-gpu-config -n osggpus
	kubectl create configmap osg-wn-prp-gpu-config -n osggpus --from-file=30_gpu.config=wn-gpu.d/30_gpu.config 

configmap_opt:
	-kubectl delete configmap osg-wn-prp-opt-config -n osggpus
	kubectl create configmap osg-wn-prp-opt-config -n osggpus --from-file=51_rank_opportunistic.config=wn-gpu.d/51_rank_opportunistic.config
