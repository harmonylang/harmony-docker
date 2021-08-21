# Pre-reqs:
# 1. Create a directory named harmony-master with the following files:
# - harmony.py
# - charm.c
# - code/ directory
# - modules/ directory
#
# 2. Have a wrapper script named wrapper.sh, where we can place
# some basic setup procedures if ever needed.

FROM alpine:latest

COPY harmony-master /harmony

# Dependencies for compiling and model checking
RUN apk update && \
    apk add python3 && \
    apk add gcc && \
    apk add musl-dev

# Copy a wrapper script into the image
RUN (cd /harmony && chmod +x wrapper.sh)

# Compile the model checker.
RUN (cd /harmony && gcc -O3 -std=c99 -DNDEBUG charm.c -m64 -o charm.exe)

# Run model checker on an example Harmony file as a sanity check,
# preferably that should asserts a concurrency issue.
RUN (cd /harmony && ./wrapper.sh code/Diners.hny)

# Remove all unnecessary files/directories
RUN (cd /harmony && rm -rf code archive.xml charm.c python install.py harmony.bat charm.Windows.exe README.txt)

# This will start a new image with alpine:latest as the base
FROM alpine:latest

# Dependency for compiler. We don't need gcc since it's already been compiled
# in the previous image.
RUN apk update && \
    apk add python3
# Copy over files from the previous image into the newer, smaller image
COPY --from=0 /harmony /harmony
