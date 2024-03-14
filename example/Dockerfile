# Official Dart image: https://hub.docker.com/_/dart
FROM dart:stable AS build
RUN apt-get update && apt-get install -y build-essential

# Set the working directory
WORKDIR /app
COPY . .

RUN make build_all

# Build minimal serving image
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Start server
EXPOSE 8080
ENTRYPOINT ["/app/bin/server"]