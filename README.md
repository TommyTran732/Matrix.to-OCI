# Matrix.to-Docker

![Build, scan & push](https://github.com/tommytran732/Matrix.to-Docker/actions/workflows/build.yml/badge.svg)

Matrix.to is a simple url redirection service for the Matrix.org ecosystem which lets users share links to matrix entities without being tied to a specific app. Stylistically it serves as a landing page for rooms and communities.

This is my own Docker image building from [the official repository](https://github.com/matrix-org/matrix.to).

### Notes
- Prebuilt images are available at `ghcr.io/tommytran732/matrix.to`.
- Don't trust random images: build yourself if you can.
- Default Element instance is changed from [Element.io](https://app.element.io) to [ArcticFoxes.net](https://element.arcticfoxes.net)
- The Dockerfile builds from the main branch, as releases do not come out frequently.
- `yarn.lock` is ignored, as upstream does not bump dependencies properly.
- The image comes with the [hardened memory allocator](https://github.com/GrapheneOS/hardened_malloc) built from the latest tag.
