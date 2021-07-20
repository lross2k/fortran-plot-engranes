@ECHO OFF
CD ../src
gfortran -c *.f90
REM gfortran *o -g03 -o build -LC:\MinGW\mingw64\bin -libquadmath-0.dll
gfortran -g03 *o -o build -static-libgfortran C:\MinGW\mingw64\lib\gcc\x86_64-w64-mingw32\8.1.0\libgfortran.a -LC:\\MinGW\\mingw64\\bin\\ -lwinpthread-1 -lquadmath-0 --no-whole-file
MOVE build.exe ../build/

Rem DEL /Q *.mod
Rem DEL /Q *.o
Rem SET var = %CD%
Rem ECHO %var%

REM gfortran *o -o build C:\MinGW\mingw64\lib\gcc\x86_64-w64-mingw32\8.1.0\libgfortran.a -LC:\\MinGW\\mingw64\\bin\\ -lwinpthread-1 -lquadmath-0
REM gfortran -g03 *o -o build -static-libgfortran C:\MinGW\mingw64\lib\gcc\x86_64-w64-mingw32\8.1.0\libgfortran.a -LC:\\MinGW\\mingw64\\bin\\ -lwinpthread-1 -lquadmath-0 -mwindows --no-whole-file