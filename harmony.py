"""
This is a wrapper command for a Harmony image run by Docker
"""
import argparse
import sys
import uuid
from pathlib import Path
import subprocess
from typing import List, Tuple


def build_docker_run_command(opts: List[str], files: List[str], max_memory: int = None) -> Tuple[List[str], str]:
    cmd = ["docker", "run"]
    if max_memory:
        cmd.extend(['-m', f"{max_memory}M", '--memory-swap', f"{max_memory}M"])
    name = str(uuid.uuid4())
    cmd.extend(['--name', name])

    cmd.extend(['-v', str(Path.cwd()) + ':/code'])
    cmd.extend(['-w', '/harmony'])
    cmd.extend(['-t', 'harmony-docker'])
    files_in_container = ['/'.join(('..', 'code', f)) for f in files]
    cmd.extend(['./wrapper.sh'] + opts + files_in_container)
    return cmd, name


def build_docker_clean_command(name: str):
    return f"docker container rm {name}".split(' ')


def build_get_json_command(name: str):
    return f"docker cp {name}:/harmony/charm.json {str(Path.cwd() / 'charm.json')}".split(' ')


def build_get_html_command(name: str):
    return f"docker cp {name}:/harmony/harmony.html {str(Path.cwd() / 'harmony.html')}".split(' ')


def main(opts, args):
    run_cmd, name = build_docker_run_command(opts, args)
    get_json_cmd = build_get_json_command(name)
    get_html_cmd = build_get_html_command(name)
    clean_cmd = build_docker_clean_command(name)

    if subprocess.run(run_cmd).returncode == 0:
        subprocess.run(get_json_cmd)
        subprocess.run(get_html_cmd)

    subprocess.run(clean_cmd)


if __name__ == '__main__':
    options = []
    files = []
    handlers = {
        'a': lambda _: options.extend(['-a']),
        'A': lambda _: options.extend(['-A']),
        'j': lambda _: options.extend(['-j']),
        'f': lambda _: options.extend(['-f']),
        'b': lambda _: options.extend(['-b']),
        'd': lambda _: options.extend(['-d']),
        'const': lambda c: options.extend(['--const', c[0]]),
        'module': lambda m: options.extend(['--module', m[0]]),
        's': lambda _: options.extend(['-s']),
        't': lambda _: options.extend(['-t']),
        'version': lambda _: options.extend(['-v']),
        'files': lambda file_paths: files.extend([str(f) for f in file_paths]),
    }
    parser = argparse.ArgumentParser()
    parser.add_argument('-a')
    parser.add_argument('-A')
    parser.add_argument('-j')
    parser.add_argument('-f')
    parser.add_argument('-b')
    parser.add_argument('-d')
    parser.add_argument('--const', '-c', nargs=1)
    parser.add_argument('--module', '-m', nargs=1)
    parser.add_argument('-s')
    parser.add_argument('-t')
    parser.add_argument('--version', '-v')
    parser.add_argument('files', type=Path, nargs='+')

    arguments = sys.argv[1:]
    result = parser.parse_args(arguments)
    for r, v in result.__dict__.items():
        if v is not None:
            handlers.get(r)(v)

    main(options, files)
