FROM gcc:12-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    libmosquitto-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone and install libabbaurora
RUN git clone --depth 1 https://github.com/ahpohl/libabbaurora.git /tmp/libabbaurora \
    && cd /tmp/libabbaurora \
    && sed -i 's/ln\s-sr\(.*\)/ln -s \1/g' Makefile \
    && PREFIX=/usr make install

# Copy and build solarmeter
COPY include /tmp/solarmeter/include
COPY src /tmp/solarmeter/src
COPY Makefile /tmp/solarmeter/Makefile
COPY resources/config /tmp/solarmeter/resources/config
WORKDIR /tmp/solarmeter
RUN make install PREFIX=/usr

# Copy example config to default location
COPY resources/config/solarmeter_example.conf /etc/solarmeter.conf

WORKDIR /app
ENTRYPOINT ["/usr/local/bin/solarmeter", "-c", "/etc/solarmeter.conf"]
