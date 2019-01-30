.PHONY: configmap

configmap:
	-kubectl delete secret osg-wn-prp-sdsc-config -n isfiligoi
	kubectl create secret generic osg-wn-prp-sdsc-config -n isfiligoi --from-file=pool_password --from-file=50_condor_host.config

