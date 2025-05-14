#!/bin/bash
exec redis-server --save 20 1 \
    --loglevel warning \
    --requirepass "$REDIS_PASSWORD"
