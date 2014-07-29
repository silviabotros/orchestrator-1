#!/bin/bash

# Simple packaging of orchestrator
#
# Requires fpm: https://github.com/jordansissel/fpm
#

release_version="1.0.4"
release_dir=/tmp/orchestrator-release
release_files_dir=$release_dir/orchestrator
rm -rf $release_dir/*
mkdir -p $release_files_dir/

cd  $(dirname $0)
rsync -av ./resources $release_files_dir/
rsync -av ./conf $release_files_dir/
GOPATH=/usr/share/golang:$(pwd)
go build -o $release_files_dir/orchestrator ./src/github.com/outbrain/orchestrator/main.go

cd $release_dir
# tar packaging
tar cfz orchestrator-"${release_version}".tar.gz ./orchestrator
# rpm packaging
fpm -v "${release_version}" -f -s dir -t rpm -n orchestrator -C $release_dir --prefix=/usr/local ./orchestrator
fpm -v "${release_version}" -f -s dir -t deb -n orchestrator -C $release_dir --prefix=/usr/local ./orchestrator

echo "---"
echo "Done. Find releases in $release_dir"
