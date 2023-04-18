ARG RUBY_VERSION="2.7.7"

FROM dreg.sbmt.io/instamart/base/ruby:${RUBY_VERSION}-build AS instamart


RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        mariadb-server libmariadb-dev \
        postgresql postgresql-client postgresql-contrib libpq-dev \
        redis-server memcached \
        ffmpeg mupdf mupdf-tools libvips poppler-utils

#
# RUN apt-get install wget 
#
# ARG IMAGEMAGICK_VERSION="7.1.0-5"
# RUN wget -qO /tmp/im.tar.xz https://imagemagick.org/archive/releases/ImageMagick-$IMAGEMAGICK_VERSION.tar.xz \
#     && wget -qO /tmp/im.sig https://imagemagick.org/archive/releases/ImageMagick-$IMAGEMAGICK_VERSION.tar.xz.asc \
#     && gpg --batch --keyserver keyserver.ubuntu.com --recv 89AB63D48277377A \
#     && gpg --batch --verify /tmp/im.sig /tmp/im.tar.xz \
#     && tar xJf /tmp/im.tar.xz -C /tmp \
#     && cd /tmp/ImageMagick-$IMAGEMAGICK_VERSION \
#     && ./configure --with-rsvg && make -j 9 && make install \
#     && ldconfig /usr/local/lib \
#     && rm -rf /tmp/*

RUN apt-get install -y --no-install-recommends \
    libsqlite3-dev \
    postgresql-client \
    libpq-dev \
    libxslt-dev libxml2-dev \
    libncurses5-dev libncursesw5-dev && \
    rm -rf /var/lib/apt/lists/*

RUN gem install pg -- --with-pg-lib=/usr/lib
# Add the Rails main Gemfile and install the gems. This means the gem install can be done
# during build instead of on start. When a fork or branch has different gems, we still have an
# advantage due to caching of the other gems.
RUN mkdir -p /tmp/rails
COPY Gemfile Gemfile.lock RAILS_VERSION rails.gemspec /tmp/rails/
COPY actioncable/actioncable.gemspec /tmp/rails/actioncable/
# COPY actionmailbox/actionmailbox.gemspec /tmp/rails/actionmailbox/
COPY actionmailer/actionmailer.gemspec /tmp/rails/actionmailer/
COPY actionpack/actionpack.gemspec /tmp/rails/actionpack/
# COPY actiontext/actiontext.gemspec /tmp/rails/actiontext/
COPY actionview/actionview.gemspec /tmp/rails/actionview/
COPY activejob/activejob.gemspec /tmp/rails/activejob/
COPY activemodel/activemodel.gemspec /tmp/rails/activemodel/
COPY activerecord/activerecord.gemspec /tmp/rails/activerecord/
# COPY activestorage/activestorage.gemspec /tmp/rails/activestorage/
COPY activesupport/activesupport.gemspec /tmp/rails/activesupport/
COPY railties/railties.gemspec /tmp/rails/railties/

RUN cd /tmp/rails \    
    && bundle install \
    && yarn install \
    && rm -rf /tmp/rails

WORKDIR /app
COPY ./boot.sh .
RUN chmod +x /app/boot.sh
ENTRYPOINT ["./boot.sh"]
