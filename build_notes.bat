@echo off
REM Convert notes.md to notes.pdf with bibliography
pandoc notes.md -o notes.pdf --citeproc --bibliography=refs.bib --pdf-engine=xelatex
pause
