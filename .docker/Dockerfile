FROM ruby:3.3-slim AS build

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libssl-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

# ──────────────────────────────────────────────
FROM ruby:3.3-slim AS runtime

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends libssl3 \ 
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# accept build arguments for user/group ID
ARG APP_USER_UID
ARG APP_USER_GID
 
# Create the group and User
RUN groupadd -g ${APP_USER_GID} app_group && useradd -r -m -u ${APP_USER_UID} -g app_group app_user
 
# Create application folder
RUN mkdir -p /app && chown app_user:app_group /app

WORKDIR /app
 
# Switch to application user
USER app_user:app_group

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app .

COPY --chown=app_user:app_group Gemfile Gemfile.lock ./
 
RUN chmod +x bin/start

CMD ["bin/start"]
