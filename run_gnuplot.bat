@echo off
set var=%cd%
cd bin
build -gnu
move *dat %var%/
