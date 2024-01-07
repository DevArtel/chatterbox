# Official Dart image: https://hub.docker.com/_/dart
FROM dart:stable AS build

# Copy lib and get dependencies
WORKDIR /app
COPY . .
RUN dart pub get

# Set the working directory for example, copy its contents and get dependencies
WORKDIR /app/example
RUN dart pub get
RUN dart run build_runner build --delete-conflicting-outputs


RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/example/bin/server /app/bin/

# Start server
EXPOSE 8080
ENTRYPOINT ["/app/bin/server"]
