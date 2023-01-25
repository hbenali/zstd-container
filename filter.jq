.data.repository.releases.nodes
    | map(
        { name: .tag.name } + { asset:
            .releaseAssets.nodes
                | map(
                    .name
                    | select(
                        test("^zstd-\\d+\\.\\d+\\.\\d+\\.tar\\.zst$")
                    )
                )
                | first
        }
    )
    | map(select(.asset != null))
    | map(.name | gsub("v(?<version>.+)"; "\(.version)"))
