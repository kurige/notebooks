
# Pull base image
FROM ubuntu:trusty
MAINTAINER me@cgateley.com

# Add julia-related PPAs. This, unfortunately requires running the time-
# consuming `apt-get update` multiple times...
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common && \
  # Add julia ppas
  add-apt-repository -y ppa:staticfloat/juliareleases && \
  add-apt-repository -y ppa:staticfloat/julia-deps

# Install packages. This includes python packages we would normally install
# through pip, since this way they will come pre-packaged with any required
# system libraries.
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    pkg-config \
    libnettle4 \
    imagemagick \
    ipython \
    ipython-notebook \
    python-numpy \
    python-scipy \
    python-matplotlib \
    julia

# Install julia, several julia packages, and create an IJulia profile
ENV IPYTHONDIR /opt/ipython
ENV JULIA_PKGDIR /opt/julia
RUN \
  mkdir -p /opt/ipython /opt/julia && \
  julia -e 'Pkg.init();' && \
  touch /opt/julia/v0.3/REQUIRE && \
  echo "IJulia" >> /opt/julia/v0.3/REQUIRE && \
  echo "PyPlot" >> /opt/julia/v0.3/REQUIRE && \
  echo "Wavelets" >> /opt/julia/v0.3/REQUIRE && \
  echo "Gadfly" >> /opt/julia/v0.3/REQUIRE && \
  echo "Images" >> /opt/julia/v0.3/REQUIRE && \
  julia -e 'Pkg.resolve()'

# Install MathJax locally
# Currently returns 404. Will do without for now.
#RUN python -m IPython.external.mathjax

# IPython's notebook server port
EXPOSE 8998

# Define working directory
WORKDIR /data

# Default command
CMD ["bash"]
