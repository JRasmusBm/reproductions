# Issue Description

This branch is a minimal reproduction of an issue we have been having at work
with `docker-compose` version 2. The above configuration works fine in version
1.27.4, but breaks in version 2.

## Output with version 1.27.4 (Expected)

> docker-compose up

```
bash_1    | bash
python_1  | python
reproductions_bash_1 exited with code 0
reproductions_python_1 exited with code 0
```

## Output with version v2.0.0-rc.3 (Unexpected)

> docker compose up

```
bash_1    | python: can't open file '//sh': [Errno 2] No such file or directory
python_1  | python
bash_1 exited with code 2
python_1 exited with code 0
```
