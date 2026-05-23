FROM busybox
WORKDIR /watcher
COPY watcher.sh .

RUN adduser -DHs /bin/sh example
RUN chown example watcher.sh
RUN chmod a+x watcher.sh
USER example

CMD ["/bin/sh", "watcher.sh"]