#!/bin/sh -x

target_dirs=`find . -type f -name "Dockerfile" -exec dirname {} \; | sort -u`
for target in ${target_dirs}
do
  container_name=$(echo $target | awk '{i=split($0,array,"/");print array[i]}')
  docker_filepath=${target}
  repository_uri=${REGISTRY_URI}/${container_name}
  aws ecr create-repository --repository-name ${container_name} --region ap-northeast-1 || true
  docker pull $repository_uri:latest || true
  docker build --cache-from $repository_uri:latest --build-arg BUILDKIT_INLINE_CACHE=1 -t $repository_uri:$image_tag -f ${docker_filepath}/Dockerfile ${docker_filepath}
  image_digest=$(docker images $repository_uri --format "{{.Tag}}\t{{.Digest}}" | awk '$1 == "'"${image_tag}"'" {print $2}')
  if [ "${image_digest}" == "<none>" ]; then
    docker tag $repository_uri:$image_tag $repository_uri:latest
    docker push $repository_uri:$image_tag
    docker push $repository_uri:latest
  fi
done