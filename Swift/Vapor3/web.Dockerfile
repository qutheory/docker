# Set to Swift 4.2, this can be changed to another version if needed
FROM swift:4.2 as builder
WORKDIR /app/
COPY . .

RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so /build/lib
RUN swift build -c release

RUN mv `swift build -c release --show-bin-path` /build/bin

FROM ubuntu:16.04

RUN \
  apt-get -q update && apt-get -q -y install \
  libatomic1 \
  libbsd0 \
  libcurl3 \
  libicu55 \
  libxml2 \
  && rm -r /var/lib/apt/lists/*
WORKDIR /app/
COPY --from=builder /build/bin .
COPY --from=builder /build/lib/* /usr/lib/

# Uncomment the following lines if you have Public or Resources folder
#COPY --from=builder /app/Public ./Public
#COPY --from=builder /app/Resources ./Resources

ENTRYPOINT ./Run serve --hostname 0.0.0.0 --port 80
