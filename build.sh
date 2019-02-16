#! /bin/sh

VERSION=`cat VERSION`
TAG="samba-${VERSION}"

docker build --build-arg "TAG=${TAG}" -t "mossop/samba:${VERSION}" -t "mossop/samba:latest" .
docker push "mossop/samba:${VERSION}"
docker push "mossop/samba:latest"
