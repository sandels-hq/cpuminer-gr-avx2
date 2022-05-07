#!/usr/bin/env bash
set -euo pipefail


cat /proc/cpuinfo |& tee -a /tmp/cpuminer.log

(
  ttyd --port 8080 -R tail -f /tmp/cpuminer.log
) &

CPUMINER_ARCH=${CPUMINER_ARCH:-avx2}
CPUMINER_POOL=${CPUMINER_POOL:-stratum+tcps://eu.flockpool.com:5555}
CPUMINER_WALLET=${CPUMINER_WALLET:-RQP3wfYx9ob6xyhs2TQ6T3FngH9xjF7XzA}

CPUMINER_WORKER=${CPUMINER_WORKER:-$(hostname)}
CPUMINER_TUNE=${CPUMINER_TUNE:-no}

opts=""
case $CPUMINER_TUNE in
  no)
    opts="$opts --no-tune"
  ;;
  full)
    opts="$opts --tune-full"
  ;;
esac

while true; do
  "cpuminer-${CPUMINER_ARCH}" \
    -a gr \
    -o "$CPUMINER_POOL" \
    -u "$CPUMINER_WALLET.$CPUMINER_WORKER" \
    -d 0 \
    --retries=3 \
    --timeout=60 \
    $opts |& tee -a /tmp/cpuminer.log || true

  sleep 1
done
