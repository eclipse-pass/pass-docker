#! /bin/sh

PI_FEDORA_EXTERNAL_BASE="http://pass.local:8080/fcrepo/rest"
PI_FEDORA_USER="fedoraAdmin"
PI_FEDORA_PASS="moo"
PI_MAX_ATTEMPTS=200

CMD="curl -I -u ${PI_FEDORA_USER}:${PI_FEDORA_PASS} --write-out %{http_code} --silent -o /dev/stderr ${PI_FEDORA_EXTERNAL_BASE}"
echo "Waiting for response from Fedora via 'curl -I -u <u>:<p> ${PI_FEDORA_EXTERNAL_BASE}'"

RESULT=0
max=${PI_MAX_ATTEMPTS}
i=1

until [ ${RESULT} -eq 200 ]
do
    sleep 5
    
    RESULT=$(${CMD})

    if [ $i -eq $max ]
    then
        echo "Reached max attempts"
        docker compose ps
        exit 1
    fi

    i=$((i+1))
    echo "Trying again, result was ${RESULT}"
done

echo "Fedora is up."