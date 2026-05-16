FROM busybox
WORKDIR /mailer

# Copy files to the WORKDIR (.) instead of root (/)
COPY mailer.sh .

# busybox doesn't include bash. Use /bin/sh instead.
RUN adduser -DHs /bin/sh example

# Combine into one layer for efficiency
RUN chown example mailer.sh && chmod a+x mailer.sh

EXPOSE 33333

USER example
CMD ["/bin/sh", "mailer.sh"]
