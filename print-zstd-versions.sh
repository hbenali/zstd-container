#!/bin/sh
if [ -n "$GITHUB_TOKEN" ]; then
curl --silent -g -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -d '{ "query": "{ repository(owner: \"facebook\", name: \"zstd\") { releases(first: 100) { nodes { tag { name } } } }}" }' \
    https://api.github.com/graphql \
    | jq -c '.data.repository.releases.nodes | map(.tag.name | select(test("^v\\d+\\.\\d+\\.\\d+$")) | gsub("v(?<version>.+)"; "\(.version)"))'
else
    echo '["1.5.2","1.5.1","1.5.0"]'
fi
