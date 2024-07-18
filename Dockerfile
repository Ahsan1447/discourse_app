# Use an official Ruby runtime as a parent image
FROM ruby:3.2.0

# Set environment variables
ENV LANG=C.UTF-8 \
    BUNDLE_PATH=/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install Rails
RUN gem install rails -v '7.1.3.4'

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs $BUNDLE_JOBS --retry $BUNDLE_RETRY

# Copy the main application
COPY . .

# Expose port 3000 to the Docker host
EXPOSE 3000

# Start Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
