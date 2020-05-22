.PHONY: secret_pool configmap configmap_base configmap_gpu configmap_opt

all: configmap

secret_pool:
	-kubectl delete secret osg-pool-sdsc-config -n osg
	kubectl create secret generic osg-pool-sdsc-config -n osg --from-file=pool_password
	-kubectl delete secret osg-pool-sdsc-config -n osggpus
	kubectl create secret generic osg-pool-sdsc-config -n osggpus --from-file=pool_password
	-kubectl delete secret osg-pool-sdsc-config -n osgcpus
	kubectl create secret generic osg-pool-sdsc-config -n osgcpus --from-file=pool_password

configmap: configmap_base configmap_gpu configmap_opt

configmap_base:
	-kubectl delete configmap osg-wn-prp-config -n osggpus
	kubectl create configmap  osg-wn-prp-config -n osggpus \
             --from-file=50_condor_host.config=wn-gpu.d/50_condor_host.config --from-file=02_memory_limits.config=wn-gpu.d/02_memory_limits.config \
             --from-file=add_image_users.sh=wn-gpu.d/add_image_users.sh
	-kubectl delete configmap osg-wn-prp-config -n osgcpus
	kubectl create configmap  osg-wn-prp-config -n osgcpus \
             --from-file=50_condor_host.config=wn-gpu.d/50_condor_host.config --from-file=02_memory_limits.config=wn-gpu.d/02_memory_limits.config \
             --from-file=add_image_users.sh=wn-gpu.d/add_image_users.sh

configmap_gpu:
	-kubectl delete configmap osg-wn-prp-gpu-config -n osggpus
	kubectl create configmap osg-wn-prp-gpu-config -n osggpus --from-file=30_gpu.config=wn-gpu.d/30_gpu.config 
	# kubectl create configmap osg-wn-prp-gpu-config -n osggpus --from-file=30_gpu.config=wn-gpu.d/30_gpu.config  -o yaml --dry-run |kubectl replace -f -

configmap_wn_cpu:
	-kubectl delete configmap osg-wn-prp-cpu-config -n osgcpus
	kubectl create configmap osg-wn-prp-cpu-config -n osgcpus \
             --from-file=02_memory_limits_20g.config=wn-cpu.d/02_memory_limits_20g.config \
             --from-file=02_memory_limits_10g.config=wn-cpu.d/02_memory_limits_10g.config \
             --from-file=09_icecube.config=wn-cpu.d/09_icecube.config
        # kubectl create configmap ...  -o yaml --dry-run |kubectl replace -f -


configmap_opt:
	-kubectl delete configmap osg-wn-prp-opt-config -n osggpus
	kubectl create configmap osg-wn-prp-opt-config -n osggpus \
             --from-file=51_rank_opportunistic.config=wn-gpu.d/51_rank_opportunistic.config \
             --from-file=51_rank_nice.config=wn-gpu.d/51_rank_nice.config

