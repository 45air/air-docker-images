#!/bin/sh

children=""
for version in $(ls -1 phpfpm)
do
  tmpFile=$(mktemp --tmpdir=. "php$version.XXX.log")
  docker build --pull --no-cache -t "45air/phpfpm:$version" "phpfpm/$version" > $tmpFile 2>&1 &
  pid="$!"
  echo "Building $version (PID $pid, output in $tmpFile)..."
  children+=" $version:$pid"
done

exitcode=0
errorMsg="The following versions failed:"
for versions in $children
do
	pid=${versions##*:}
	ver=${versions%%:*}
	if wait $pid ; then
		rm php$ver.*.log
	else
		errorMsg+=" $ver"
		exitcode=$(($exitcode+1))
	fi
done

if (( $exitcode > 0 )); then
	2>&1 echo $errorMsg
	exit $exitcode
fi

docker tag 45air/phpfpm:7.3 45air/phpfpm:latest

echo "Pushing images..."
for version in $(ls -1 phpfpm)
do
	docker push 45air/phpfpm:$version > /dev/null 2>&1 &
done
docker push 45air/phpfpm:latest > /dev/null 2>&1 &
wait
