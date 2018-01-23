FROM fluent/fluentd:stable-debian-onbuild

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish

ENV ELASTICSEARCH="elastic"

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps curl \
 && sudo gem install \
        fluent-plugin-elasticsearch \
 && sudo gem install \
        fluent-plugin-concat \
 && sudo gem install \
        fluent-plugin-grok-parser \
 && sudo gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
           /home/fluent/.gem/ruby/2.3.0/cache/*.gem

copy wait-for-elastic.sh /
CMD exec ./wait-for-elastic.sh $ELASTICSEARCH $FLUENTD_CONF $FLUENTD_OPT
