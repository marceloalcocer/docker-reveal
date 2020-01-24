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


## Building

Build the image from the [Dockerfile](./Dockerfile), e.g.

```sh
$ docker image build
```

### Build arguments

Argument           | Default | Description
-------------------|---------|-------------------------------------------------------------------
`VERSION_REVEAL`   | 3.8.0   | [reveal.js version](https://github.com/hakimel/reveal.js/releases)
`VERSION_MATHJAX`  | 2.7.7   | [MathJax version](https://github.com/mathjax/MathJax-src/releases)

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
    -p 8080:8000 \
    reveal
```

serves the presentation from `http://<HOST>:8080`

### Presentation contents

To serve a presentation, bind mount its contents directly to the container's `/reveal.js` directory so as to shadow the default presentation contents. This should be done on a file-by-file basis.

E.g.

```sh
$ docker run \
    --init \
    -p 8080:8000 \
    --mount type=bind,source=/my/presentation/index.html,target/reveal.js/index.html \
    --mount type=bind,source=/my/presentation/custom.css,target/reveal.js/custom.css \
    reveal
```

serves the presentation comprised of `index.html` and `custom.css` from `http://<HOST>:8080`
