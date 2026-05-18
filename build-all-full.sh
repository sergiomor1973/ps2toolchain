#!/bin/bash
set -e

echo ""
echo "==============================================="
echo "      PS2 FULL TOOLCHAIN BUILD (EE + IOP + DVP)"
echo "==============================================="
echo ""

cd "$(dirname "$0")"

# 1. Build DVP
echo "=== [1/3] Building DVP ==="
cd build/ps2toolchain-dvp
bash build-all.sh
cd ../..

# 2. Build IOP
echo ""
echo "=== [2/3] Building IOP ==="
cd build/ps2toolchain-iop
bash build-all.sh
cd ../..

# 3. Build EE
echo ""
echo "=== [3/3] Building EE ==="
cd build/ps2toolchain-ee
bash build-all.sh
cd ../..

echo ""
echo "==============================================="
echo "         PS2 TOOLCHAIN COMPLETO!"
echo "==============================================="
echo ""
