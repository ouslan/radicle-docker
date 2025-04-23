# Use a minimal base image
FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && apt-get install -y \
  curl \
  tar \
  xz-utils \
  && rm -rf /var/lib/apt/lists/*

# Create system group and user
RUN groupadd --system seed && \
  useradd --system --gid seed --create-home seed

# Setup directories and permissions
RUN mkdir -p /usr/local/bin /usr/local/man/man1 && \
  chown root:seed /usr/local/bin /usr/local/man /usr/local/man/man1

# Set environment variable for radicle home
ENV RAD_HOME=/home/seed/.radicle

# Create radicle directory
RUN mkdir -p $RAD_HOME && chown seed:seed $RAD_HOME

# Switch to non-root user
USER seed
WORKDIR $RAD_HOME

# Download and extract Radicle
RUN curl -O -L https://files.radicle.xyz/releases/latest/radicle-linux.tar.xz && \
  tar -xvJf radicle-linux.tar.xz --strip-components=1 -C $RAD_HOME && \
  rm radicle-linux.tar.xz

# Add to PATH
ENV PATH="$RAD_HOME:$PATH"

# Authenticate with alias
RUN rad auth --alias seed.radicle.example

# Start rad node on container run
CMD ["rad", "node"]
