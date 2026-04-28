FROM dart:stable

WORKDIR /app

# Install dependencies
COPY pubspec.* ./
RUN dart pub get

# Copy full backend
COPY . .

# Expose port
EXPOSE 8080

# Run server
CMD ["dart", "run", "bin/server.dart"]