#!/bin/bash

user=${1:-bikramtuladhar}
org="cloudnepal"

while STARS=$(curl -u "bikramtuladhar:$super_secret" -s "https://api.github.com/users/$user/starred?per_page=100&page=${page:-1}" |jq -r -e '.[].full_name' && [[ ${PIPESTATUS[1]} != 4 ]]); do
	
	starsArray=($STARS)
	
	for star in "${starsArray[@]}"
	do
		name=${star#*/}

		curl \
		  -X POST \
		  -H "Accept: application/vnd.github+json" \
		  -H "Authorization: Bearer $super_secret" \
		  "https://api.github.com/repos/$star/forks" \
		  -d '{"organization":"'$org'","name":"'$name'","default_branch_only":true}' > /dev/null

        sleep 4

        curl \
        -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $super_secret" \
        "https://api.github.com/repos/$org/$name/merge-upstream" \
        -d '{"branch":"main"}' 

        sleep 3

        curl \
        -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $super_secret" \
        "https://api.github.com/repos/$org/$name/merge-upstream" \
        -d '{"branch":"master"}'
        
        sleep 3
	done

    let page++
done