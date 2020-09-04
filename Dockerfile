# docker-reveal
#
#   Dockerized reveal.js presentation framework with baked in MathJax
#   installation
#


# Source fetch stage
# -------------------
ARG VERSION_NODE=14.9
ARG VERSION_ALPINE=3.12
FROM alpine:$VERSION_ALPINE as fetch

# Image arguments
ARG VERSION_REVEAL=4.0.2
ARG VERSION_MATHJAX=2.7.7
# ARG VERSION_MATHJAX=3.0.0                           # ≥ 3.0.0 Requires build
ARG REPO_REVEAL=https://github.com/hakimel/reveal.js
ARG REPO_MATHJAX=https://github.com/mathjax/MathJax

# Install fetch dependenceis
RUN apk add --no-cache wget

# Fetch source archives
RUN \
	   wget -qO reveal.js.tar.gz $REPO_REVEAL/archive/$VERSION_REVEAL.tar.gz \
	&& wget -qO MathJax.tar.gz $REPO_MATHJAX/archive/$VERSION_MATHJAX.tar.gz

# Unpack source archives
RUN \
	   tar -xzf reveal.js.tar.gz \
	&& mv reveal.js-$VERSION_REVEAL reveal.js \
	&& tar -xzf MathJax.tar.gz \
	&& mv MathJax-$VERSION_MATHJAX reveal.js/mathjax


# Build stage
# ------------
FROM node:$VERSION_NODE-alpine$VERSION_ALPINE AS build

# Copy source
COPY --from=fetch reveal.js reveal.js

# Install build dependencies
RUN apk add --no-cache --virtual \
		make \
		python3

# Build and install dependencies
RUN	\
	   cd reveal.js \
	&& npm install \
	&& ln -s node_modules/gulp/bin/gulp.js gulp

# De-escalate permissions
RUN chown -R node:node reveal.js


# Package stage
# --------------
FROM node:$VERSION_NODE-alpine$VERSION_ALPINE AS package

# Metadata
LABEL description="reveal.js presentation framework with baked in MathJax installation"
LABEL maintaner="marcelo.j.p.alcocer@gmail.com"
LABEL reveal.js="https://github.com/hakimel/reveal.js/"
LABEL MathJax="https://github.com/mathjax/MathJax"

# Copy runtime dependencies
COPY --from=build reveal.js reveal.js

# Set user
USER node

# Set working directory
WORKDIR reveal.js

# Expose port
EXPOSE 8000

# Serve
ENTRYPOINT ["./gulp", "serve"]
