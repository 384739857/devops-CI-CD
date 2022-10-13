#!/usr/bin/env sh
#./pkg.sh 
# 示例:
# eureka-service auth-server mds-server dqs-server ds-server 
# idcenter-service tag-server uc-server workflow-server 
# kc-server auth-frontier-service mds-all-frontier-service

#./pkg.sh  idcenter-service  workflow-server tag-server drd-server drd-frontier-service  mds-server dqs-server kc-server  mds-all-frontier-service pmc-server uc-server auth-server auth-frontier-service
#./pkg.sh  dqs-server mds-all-frontier-service 


# 上海POC 
#./pkg.sh  idcenter-service  workflow-server tag-server mds-server dqs-server kc-server  mds-all-frontier-service pmc-server uc-server auth-server auth-frontier-service


# daxing
#./pkg.sh  drd-server drd-frontier-service 


# 海南
./pkg.sh idcenter-service  workflow-server tag-server   mds-server dqs-server kc-server  mds-all-frontier-service pmc-server uc-server auth-server auth-frontier-service d4a-server dlc-server dpf-server dpf-server  ds-server eureka-service drd-frontier-service drd-server 
