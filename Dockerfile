FROM swift

ADD .  /src/semantics
RUN cd /src/semantics \
 && swift build \
 && swift test
