#!/bin/sh
if [ -n "$GITHUB_TOKEN" ]; then
    curl --silent -g -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -d "$(jq -c -n --arg query "$(cat query.graphql)" '{"query":$query}')" \
        https://api.github.com/graphql \
        | jq -c "$(cat filter.jq)"
else
    echo '["1.5.2","1.5.1","1.5.0","1.5.5"]'
fi
