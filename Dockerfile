# defines base image containing dependencies
FROM ubuntu:18.04 as blendsurf-deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \ 
    cmake \ 
    extra-cmake-modules \
    freeglut3-dev \
    libblas-dev \
    liblapack-dev &&\

    apt-get purge -y curl && \
    apt-get autoremove -y && \
    apt-get purge -y ca-certificates &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# defines CI build: checks that blendsurf core and renderer still compile
FROM blendsurf-deps as blendsurf-build
COPY . blendsurf/
RUN mkdir -p blendsurf/build/ 
WORKDIR blendsurf/build/
RUN cmake -DCMAKE_MODULE_PATH=/usr/share/cmake-3.10/Modules/ \
        -DCOMPILE_RENDERER=True ..  && make 

# to use the container
FROM blendsurf-build as blendsurf-dev

CMD ["/bin/bash"]
