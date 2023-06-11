# Use a base image with OCaml and opam pre-installed
FROM ocaml/opam2

# Set the working directory
WORKDIR /backend

# Copy the project files into the container
COPY . .

# Install dependencies
RUN opam install --deps-only .

# Build the project
RUN opam exec -- dune build
