#!/bin/bash

jupyter qtconsole &
nvim -c ":JupyterConnect" $1
