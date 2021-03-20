"""
This is a wrapper command for a Harmony image run by Docker
"""
import sys
import uuid
from pathlib import Path
from os import path, system
from typing import List, Tuple
import shutil


def build_docker_run_command(files: List[str], max_memory: int = None) -> Tuple[str, str]:
    cmd = ["docker", "run"]
    if max_memory:
        cmd.extend(['-m', f"{max_memory}M", '--memory-swap', f"{max_memory}M"])
    name = str(uuid.uuid4())
    cmd.extend(['--name', name])
    
    cmd.extend(['-v', str(Path.cwd()) + ':/code'])
    cmd.extend(['-w', '/harmony'])
    cmd.extend(['-t', 'harmony'])
    files_in_container = ['/'.join(('..', 'code', f)) for f in files]
    cmd.extend(['./harmony'] + files_in_container)
    return ' '.join(cmd), name


def build_docker_clean_command(name: str):
    return f"docker container rm {name}"


def build_get_json_command(name: str):
    return f"docker cp {name}:/harmony/charm.json {str(Path.cwd() / 'charm.json')}"


def build_get_html_command(name: str):
    return f"docker cp {name}:/harmony/harmony.html {str(Path.cwd() / 'harmony.html')}"


def main(args):
    run_cmd, name = build_docker_run_command(args)
    get_json_cmd = build_get_json_command(name)
    get_html_cmd = build_get_html_command(name)
    clean_cmd = build_docker_clean_command(name)

    if system(run_cmd) == 0:
        system(get_json_cmd)
        system(get_html_cmd)

    system(clean_cmd)


if __name__ == '__main__':
    main(sys.argv[1:])
