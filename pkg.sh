#!/bin/bash
set -xe

############################################
#
# 配置变量
#
############################################
export MVN_HOME='/data/pkgdocker/apache-maven-3.6.1'
export PATH=$MVN_HOME/bin:$PATH
export UNI_ROOT=$(pwd)
BRANCH_NAME="$1"
TAG_NAME="$2"
echo "BRANCH_NAME=$BRANCH_NAME"
echo "TAG_NAME=$TAG_NAME"
if [ $# -lt 3 ]; then
  echo "USAGE: $0 <Branch Name> <Tag Name> xxx-server yyy-server"
  exit 1
fi
mkdir -p ${UNI_ROOT}/bin/sql

############################################
#
# 编译及构建镜像
#
############################################
echo "===build docker==="
for arg in "${@:3}"; do
  echo "处理 ${arg}"
  ./common-bins/pkg_serv.sh ${BRANCH_NAME} ${arg} ${TAG_NAME} ${UNI_ROOT} ${UNI_ROOT}/bin
done

############################################
#
# 导出镜像
#
############################################
echo "===export docker==="
image_list=""
for arg in "${@:3}"; do
  image_list="${image_list}ej/${arg}:${TAG_NAME} "
done
image_list=$(echo ${image_list} | sed 's/server/service/g')
image_list=$(echo ${image_list} | sed 's/auth-frontier-service/auth-frontier/g')
image_list=$(echo ${image_list} | sed 's/mds-all-frontier-service/mds-all-frontier/g')
image_list=$(echo ${image_list} | sed 's/uc-service/usercenter-service/g')
image_list=$(echo ${image_list} | sed 's/drd-frontier-service/drd-frontier/g')
#sudo docker save ${image_list} >./bin/ej-images.tar

############################################
#
# 配置脚本
#
############################################
echo "===copy scripts ==="
for arg in "${@:3}"; do
  cat ${UNI_ROOT}/service-scripts/${arg}/deployment.yaml |
    sed 's/${TARGET_ENV}/demo/g' |
    sed 's/${EJ_NEXUS_ADDR}\///g' |
    sed 's/imagePullPolicy: Always/imagePullPolicy: IfNotPresent/g' >${UNI_ROOT}/bin/${arg}.yaml
  cat ${UNI_ROOT}/common-bins/pkg_redeploy.sh |
    sed "s/SERVICE_NAME/${arg}/g" >${UNI_ROOT}/bin/${arg}.sh
  chmod +x ${UNI_ROOT}/bin/${arg}.sh
  if [ ${arg} != "auth-frontier-service" ] && [ ${arg} != "mds-all-frontier-service" ] && [ ${arg} != "idcenter-service" ] && [ ${arg} != "eureka-service" ]&& [ ${arg} != "drd-frontier-service" ]; then
    cat ${UNI_ROOT}/modules/${arg}/ddl/${arg}.sql | sed 's/${TARGET_ENV}/demo/g' >${UNI_ROOT}/bin/sql/${arg}.sql
    cat ${UNI_ROOT}/modules/${arg}/ddl/${arg}"-"init.md | sed 's/${TARGET_ENV}/demo/g' >${UNI_ROOT}/bin/sql/${arg}-init.md
  fi
done

echo "done"