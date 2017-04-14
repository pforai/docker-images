#!/usr/bin/env bash

if [ $# -ne 2 ];then
    echo
    echo -e '\033[35m'"  Usage: $(basename ${0}) [docker-image] [workspace-root-dir]"'\033[0m'
    echo
    exit 1
fi

set -exv
docker_image=$1
root_dir=$(cd $2; pwd -P)
scripts_root_dir=$(cd $(dirname $0)/..; pwd -P)

docker_root_dir="/workspace"
docker_scripts_root_dir="/scripts_root"

echo ${scripts_root_dir}
#exit

docker info

docker run -i \
            -v "$root_dir":"$docker_root_dir" \
            -v "$scripts_root_dir":"$docker_scripts_root_dir" \
            -a stdin -a stdout -a stderr \
            $docker_image \
            bash << EOF 
set -ex
export PYTHONUNBUFFERED=1
#export scripts_root_dir="/scripts_root"
#echo ${scripts_root_dir}

bash "${docker_scripts_root_dir}"/scripts/dockerfile.sh
bash "${docker_scripts_root_dir}"/scripts/build_and_package.sh \
                                "$docker_root_dir"/eman2 \
                                "$docker_root_dir"/centos6 \
                                "${docker_scripts_root_dir}"/constructor
#echo "Hello!"

EOF