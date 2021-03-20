# Harmony-Docker

> Run Harmony wherever

## Summary

This repository contains a Dockerfile to build a Docker image, which can be used to run `Harmony` programs in a container.

## Setup

- Install [Docker](https://docs.docker.com/get-docker/) and [Python](https://www.python.org/downloads/).
- Clone or download this repository.
- Navigate to cloned/downloaded repository on your command line.
- Run `sh setup.sh` (This might take some time).
- All set to go!

## Usage

Harmony programs are run via the `harmony.py`. Assuming we have a Harmony file named `main.hny` in the current directory as `harmony.py`, we can run the following command.

```sh
python3 harmony.py test.hny
```

Running the above command will run the model checker on the Harmony program and output any additional files, such as `charm.json` and `harmony.html`.

Like in the actual Harmony compiler, you can also pass in options/flags to the command, e.g.:

```shell
python3 harmony.py -c V=21 test.hny
```

For easier use, you can add an alias for `python3 harmony.py`, e.g.:

```shell
alias harmony=python3 /path/to/harmony.py
```