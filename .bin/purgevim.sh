#!/bin/bash
for dir in backup swap undo
do
  shred -vun10 ~/.vimtemp/${dir}/*
done
