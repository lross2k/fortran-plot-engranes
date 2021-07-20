@echo off
set var=%cd%
cd bin
build -py
move *py %var%/
move *png %var%/
