echo "Building Flying Cat..."

echo "  - BareMetal OS (base)"
nasm -f bin -o bin/kernel64.sys -Ios/ os/kernel64.asm
echo "                                        [ done ]"
