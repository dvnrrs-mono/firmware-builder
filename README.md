# `firmware-builder` Docker Image

This is the Git repository for the `ghcr.io/dvnrrs-mono/firmware-builder` Docker image. This image
supports compiling firmware components for the [Mono Gateway][gateway].

## Key Features

- Based on [Ubuntu 24.04][ubuntu-2404]
- Contains `apt` packages required for firmware builds
- Contains [Arm GNU `aarch64-none-linux-gnu` toolchain][arm-gnu] for cross-compiling (included in
  `$PATH`)

# Using the Image

Pull the latest image from the GitHub Package Registry:

    docker pull ghcr.io/dvnrrs-mono/firmware-builder:latest

Start the image with an interactive shell session:

    docker run -it ghcr.io/dvnrrs-mono/firmware-builder:latest

In the interactive shell, you can now check out firmware components and build them. For
cross-compiling individual components like `atf` and `u-boot`, set up cross-compilation using the
`CROSS_COMPILE` environment variable:

    export CROSS_COMPILE=aarch64-none-linux-gnu-

Then build the component according to its instructions (for example, run `make`).

# Updating the Image Automatically

This repository includes a GitHub workflow which automatically builds and publishes images when
commits are pushed to `main` or when version tags (of the form `v*`) are pushed. As an example,
follow the steps below:

- Modify the `Dockerfile` as desired.
- Test the changes locally using `docker build .`
- Commit the changes to Git locally (`git commit`).
- Create a [semver][semver]-style tag (`git tag v1.2.3`).
- Push the changes to GitHub, including the new tag (`git push origin main v1.2.3`).

The workflow will run automatically and publish the new image with the following tags:

- `ghcr.io/dvnrrs-mono/firmware-builder:1.2.3`
- `ghcr.io/dvnrrs-mono/firmware-builder:1.2`
- `ghcr.io/dvnrrs-mono/firmware-builder:latest`

# Updating the Image Manually

If necessary, it is possible to manually push updated images without using the GitHub workflows.

- Modify the `Dockerfile` as desired.
- Test the changes locally using `docker build .`
- Note the image hash printed at the end of the `docker build` output.
- Tag the image using `docker tag (hash) ghcr.io/dvnrrs-mono/firmware-builder:1.2.3`. Repeat for
  `:latest` if desired.
- [Log into the GitHub container registry][ghcr-auth] using `docker login` using a GitHub PAT
  with the necessary package registry permissions (refer to the linked instructions).
- Push the tagged image to the container registry using
  `docker push ghcr.io/dvnrrs-mono/firmware-builder:1.2.3`. Repeat for `:latest` if desired.

[arm-gnu]: https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain
[gateway]: https://mono.si/
[ghcr-auth]: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry
[semver]: https://semver.org/
[ubuntu-2404]: https://hub.docker.com/layers/library/ubuntu/24.04/images/sha256-dc17125eaac86538c57da886e494a34489122fb6a3ebb6411153d742594c2ddc
