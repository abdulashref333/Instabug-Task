FROM ruby:3.1.2-alpine3.16

ARG APP_USER_ID

ENV APP_USER             instabug-user
ENV PROJECT_DIRECTORY    instabug-task
ENV USER_HOME_DIRECTORY  /home/${APP_USER}
ENV APP_PATH             ${USER_HOME_DIRECTORY}/${PROJECT_DIRECTORY}
ENV CACHE_DIR            ${APP_PATH}/tmp/cache
ENV NODE_MODULES_DIR     ${APP_PATH}/node_modules
ENV BUNDLED_GEMS_PATH    /bundle
ENV BUNDLE_APP_CONFIG    ${BUNDLED_GEMS_PATH}
ENV BUNDLE_BIN           ${BUNDLED_GEMS_PATH}/bin
ENV BUNDLE_PATH          ${BUNDLED_GEMS_PATH}
ENV PATH ${BUNDLE_BIN}:${PATH}

# Upgrade packages.
RUN apk --no-cache --available upgrade

# Install system dependencies required both at runtime and build time.
RUN apk add --no-cache build-base \
  git \
  mariadb-dev \
  tzdata \
  curl bash vim \
  openssh bash-completion \
  nodejs npm \
  yarn \
  gnupg \
  gcompat

WORKDIR ${USER_HOME_DIRECTORY}

RUN adduser -s /bin/bash -u ${APP_USER_ID} -h ${USER_HOME_DIRECTORY} -D ${APP_USER} && \
  mkdir -p ${APP_PATH} ${BUNDLED_GEMS_PATH} ${CACHE_DIR} ${NODE_MODULES_DIR} && \
  chown -R ${APP_USER}:${APP_USER} ${APP_PATH} ${BUNDLED_GEMS_PATH} ${CACHE_DIR} ${NODE_MODULES_DIR}

# Copy entrypoint to docker home directory
COPY docker/entrypoint.sh ${USER_HOME_DIRECTORY}/entrypoint.sh
RUN chmod +x ${USER_HOME_DIRECTORY}/entrypoint.sh

# Save Rails Console's history
RUN echo -e "require 'irb/ext/save-history'\n\
  IRB.conf[:SAVE_HISTORY] = 500\n\
  IRB.conf[:HISTORY_FILE] = '${APP_PATH}/.irb-history'\n" >> ${USER_HOME_DIRECTORY}/.irbrc

COPY docker/bashrc ${USER_HOME_DIRECTORY}/.bashrc

USER ${APP_USER}

WORKDIR ${APP_PATH}

COPY --chown=${APP_USER} Gemfile .
COPY --chown=${APP_USER} Gemfile.lock .

RUN gem install bundler -v '~> 2.5'

# Install gems.
RUN bundle install
