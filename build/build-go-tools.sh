#!/usr/bin/env bash
# Rebuilds the Go tools listed in go-tools.txt from their upstream source,
# raising the dependencies in MIN_VERSIONS to the minimum release that fixes
# their known CVEs (only when the tool already uses an older version).
set -euo pipefail

TOOLS_FILE="${1:?usage: $0 <tools file> <output dir>}"
OUT_DIR="${2:?usage: $0 <tools file> <output dir>}"

# <module> <minimum fixed version>
MIN_VERSIONS="
github.com/Azure/go-ntlmssp v0.1.1
github.com/cloudflare/circl v1.6.3
github.com/getkin/kin-openapi v0.149.0
github.com/go-git/go-billy/v5 v5.9.0
github.com/go-git/go-git/v5 v5.19.2
github.com/gofiber/fiber/v2 v2.52.14
github.com/jackc/pgx/v5 v5.9.2
github.com/klauspost/compress v1.18.7
github.com/labstack/echo/v4 v4.16.1
github.com/refraction-networking/utls v1.8.2
github.com/ulikunitz/xz v0.5.15
github.com/uptrace/bun/driver/pgdriver v1.2.15
github.com/valyala/fasthttp v1.70.0
github.com/yuin/goldmark v1.7.17
go.opentelemetry.io/otel v1.41.0
golang.org/x/crypto v0.56.0
golang.org/x/net v0.60.0
golang.org/x/oauth2 v0.27.0
golang.org/x/text v0.41.0
google.golang.org/grpc v1.83.2
"

mkdir -p "$OUT_DIR"
export CGO_ENABLED=0 GOFLAGS=-mod=mod

grep -vE '^\s*(#|$)' "$TOOLS_FILE" | while read -r name modver pkg; do
    echo "==> Building ${name} (${modver})"
    src_dir=$(go mod download -json "$modver" | jq -r .Dir)
    work_dir=$(mktemp -d)
    cp -r "$src_dir"/. "$work_dir"
    chmod -R u+w "$work_dir"
    (
        cd "$work_dir"
        # One dependency at a time, so MVS can raise transitive requirements
        # and an already newer version is never downgraded.
        while read -r dep min; do
            [ -n "$dep" ] || continue
            current=$(go list -m -f '{{.Version}}' "$dep" 2>/dev/null) || continue
            lowest=$(printf '%s\n%s\n' "$current" "$min" | sort -V | head -1)
            if [ "$current" != "$min" ] && [ "$lowest" = "$current" ]; then
                echo "    upgrading ${dep} ${current} -> ${min}"
                go get "${dep}@${min}"
            fi
        done <<< "$MIN_VERSIONS"
        go build -trimpath -ldflags="-s -w" -o "${OUT_DIR}/${name}" "$pkg"
    )
    rm -rf "$work_dir"
done
