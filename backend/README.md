# Pump Pal Backend

## Table of contents
1. [Managing Isolated Environment](#managing-isolated-environment)

## Managing Isolated Environment
### First installation
To create the isolated environment on `opam switch`, run the following:
```bash
opam switch import pp-backend-env --switch pp-backend-env
eval $(opam env)
```

### Subsequent installation
Assuming that you already have `pp-backend-dev`, run the following command if there are changes to the environment
```bash
opam switch import pp-backend-env --switch pp-backend-env
opam reinstall pp-backend-dev
eval $(opam env)
```

### To install new packages
```bash
opam install <package>
```

### To export the new isolated environment
Make sure to run this after everytime you install new packages.
```bash
opam switch export pp-backend-env
```

### To check all the isolated environment that you have 
```bash
opam switch list
```

### Resources
More information about `opam switch` can be found [here](https://opam.ocaml.org/doc/man/opam-switch.html).

## Project Structure