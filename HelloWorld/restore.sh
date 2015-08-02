#!/bin/bash
export MONO_THREADS_PER_CPU=2000
dnu restore -s https://www.myget.org/F/aspnetvnext/api/v2/ -f https://www.nuget.org/api/v2/
