#!/usr/bin/env bash
set -euxo pipefail

# Basic help test
coreutils --help

# --- cat ---
echo "hello" > input.txt
cat input.txt | grep hello

# --- echo ---
echo "coreutils test passed"

# --- basename/dirname ---
basename /usr/bin/ls
dirname /usr/bin/ls

# --- true / false ---
true
# false should return non-zero but not crash the test runner
if false; then
    echo "false returned 0 unexpectedly"
    exit 1
else
    echo "false returned nonzero as expected"
fi

# --- head ---
echo -e "1\n2\n3\n4" > head.txt
head -n 2 head.txt | grep 1
head -n 2 head.txt | grep 2

# --- wc ---
echo "abc def" > wc.txt
wc wc.txt

# --- seq ---
seq 1 3 | grep 3

# --- sleep ---
sleep 1

# --- printf ---
printf "x=%d\n" 42 | grep "x=42"

# --- env ---
env | grep PATH

# --- pwd ---
pwd

# --- whoami ---
whoami

# --- realpath ---
realpath .

# --- test command ---
test -d .
test ! -f nonexistent.file 2>/dev/null || true

# --- truncate ---
echo "123456789" > trunc.txt
truncate -s 5 trunc.txt
test "$(cat trunc.txt)" = "12345"

echo "All Unix tests passed"