# docker-reveal

Dockerized [reveal.js](https://github.com/hakimel/reveal.js/) presentation framework with baked in [MathJax](https://github.com/mathjax/MathJax) installation

## Contents

* [Building](#building)
    * [Build arguments](#build-arguments)
    * [Image size](#image-size)
* [Running](#running)
    * [Signal handling](#signal-handling)
    * [Exposed ports](#exposed-ports)
    * [Presentation contents](#presentation-contents)
    * [Debugging](#debugging)


## Building

Build the image from the [Dockerfile](./Dockerfile), e.g.

```sh
$ docker image build
```

The supplied helper script [reveal](./reveal) can also be used to set sensible build options, e.g. empty build context, image tag, compression, etc.

```sh
$ ./reveal build
```

All further arguments to `reveal build` are passed directly to `docker image build`.

### Build arguments

Argument           | Default | Description
-------------------|---------|-------------------------------------------------------------------
`VERSION_REVEAL`   | 3.8.0   | [reveal.js version](https://github.com/hakimel/reveal.js/releases)
`VERSION_MATHJAX`  | 2.7.7   | [MathJax version](https://github.com/mathjax/MathJax-src/releases)
`VERSION_NODE`     | 14.9    | Base [node.js image version](https://hub.docker.com/_/node). Must have variant based on corresponding [alpine image version](https://hub.docker.com/_/alpine)
`VERSION_ALPINE`   | 3.12    | Base [alpine image version](https://hub.docker.com/_/alpine)

### Image size

Owing to the large number of node dependencies, image sizes are typically comparable to a reveal.js source distribution size of ~ 500 MB.

## Running

### Signal handling

To allow [kernel signal handling in node.js-based containers](https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#handling-kernel-signals), the node.js process should be wrapped in an init system. This can be done by passing the `--init` flag to `docker run`;

```sh
$ docker run \
    --init \
    reveal
```

### Exposed ports

The presentation is served over HTTP from exposed container port 8000. This should therefore be published to a suitable host port.

E.g.

```sh
$ docker run \
    --init \
    -p 8000:8000 \
    reveal
```

serves the presentation from `http://<HOST>:8000`

### Presentation contents

To serve a presentation, bind mount its contents directly to the container's `/reveal.js` directory so as to shadow the default presentation contents. This should be done on a file-by-file basis.

E.g.

```sh
$ docker run \
    --init \
    -p 8000:8000 \
    --mount type=bind,source=/my/presentation/index.html,target/reveal.js/index.html \
    --mount type=bind,source=/my/presentation/custom.css,target/reveal.js/custom.css \
    reveal
```

serves the presentation comprised of `index.html` and `custom.css` from `http://<HOST>:8000`

The supplied helper script [reveal](./reveal) can be used to mount multiple files in this way.

E.g.

```sh
$ ./reveal run index.html ../../custom.css /path/to/dir
```

bind mounts `index.html`, `custom.css` and `dir` to the container's `/reveal.js` directory.

### Debugging

The supplied helper script [reveal](./reveal) can be used to start an interactive shell (`ash`) session in the container for debugging purposes,

```sh
$ ./reveal debug index.html ../../custom.css /path/to/dir
```
