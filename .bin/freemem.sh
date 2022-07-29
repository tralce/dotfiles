#!/bin/bash
/usr/bin/date
/usr/bin/free -h
/usr/bin/sync
/usr/bin/echo 3 > /proc/sys/vm/drop_caches
/usr/bin/free -h
