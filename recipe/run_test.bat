@echo on
setlocal EnableDelayedExpansion

REM ---- basic help ----
coreutils --help

REM ---- cat ----
echo hello > input.txt
coreutils cat input.txt | findstr hello

REM ---- echo ----
coreutils echo coreutils test passed

REM ---- basename / dirname ----
coreutils basename C:\Windows\System32\cmd.exe
coreutils dirname  C:\Windows\System32\cmd.exe

REM ---- true / false ----
coreutils true
coreutils false && echo ERROR false returned 0 && exit /b 1
echo false returned nonzero as expected

REM ---- head ----
(
  echo 1
  echo 2
  echo 3
  echo 4
) > head.txt
coreutils head -n 2 head.txt

REM ---- wc ----
echo abc def > wc.txt
coreutils wc wc.txt

REM ---- seq ----
coreutils seq 1 3

REM ---- sleep ----
coreutils sleep 1

REM ---- printf ----
coreutils printf "x=%d\n" 42

REM ---- env ----
coreutils env

REM ---- pwd ----
coreutils pwd

REM ---- whoami ----
coreutils whoami

REM ---- realpath ----
coreutils realpath .

REM ---- test ----
coreutils test -d .
coreutils test -f nonexistent.file && echo ERROR unexpected true && exit /b 1 || echo OK

REM ---- truncate ----
echo 123456789 > trunc.txt
coreutils truncate -s 5 trunc.txt
coreutils cat trunc.txt

echo All Windows tests passed.
endlocal
exit /b 0