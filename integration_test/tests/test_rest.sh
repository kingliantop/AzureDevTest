#!/bin/bash

echo "Testing that the web UI shows a response from the REST API"
sleep 10
rest_hostname=$(curl -q http://web | egrep -c "<p>REST hostname is .+</p>")

if [ $rest_hostname -eq 1 ]
then echo "Tests Passed"
else 
  >&2 echo "Rest API is not reporting hostname in the expected way: "e 
  >&2 echo $(curl -q http://web)
  echo "Tests Failed (see stderr for more details)"
fi
