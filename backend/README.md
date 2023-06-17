# Pump Pal Backend

## Table of contents
1. [Managing Isolated Environment](#managing-isolated-environment)
2. [Dune Lib Submodules](#dune-lib-submodules)

## Managing Isolated Environment
### First installation
To create the isolated environment on `opam switch`, run the following:
```bash
opam switch import pp-backend-env --switch pp-backend-env
eval $(opam env)
```

### Subsequent installation
Assuming that you already have `pp-backend-env`, run the following command if there are changes to the environment
```bash
opam switch import pp-backend-env --switch pp-backend-env
opam reinstall pp-backend-env
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

## Dune Lib Submodules

To achieve one directory per library, we can use the following structure

```
.
├── bin
│   ├── dune
│   └── main.ml
├── dune-project
├── lib
│   ├── suba
│   │   ├── dune
│   │   └── suba.ml
│   └── subb
│       ├── dune
│       └── subb.ml
```

The changes to the files are as follows:

`bin/main.ml`

```ocaml
let () =
  Suba.a (); 
  Subb.b ();
```

`bin/dune`

```
(executable
 (name main)
 (libraries suba subb))
```

`lib/sub{a|b}/dune`

```
(library
 (name sub{a|b}))
```

More information can be found [here](https://stackoverflow.com/questions/67462284/how-to-have-nested-libraries-confused-about-dune-etc).

## Project Structure