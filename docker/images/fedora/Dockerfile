FROM fedora:28
COPY root /opt/system/germ/
COPY run-01.sh /opt/system/seed/
RUN ["sh", "/opt/system/seed/run-01.sh"]
COPY run-02.sh /opt/system/seed/
RUN ["sh", "/opt/system/seed/run-02.sh"]
USER user
WORKDIR /home/user/
ENTRYPOINT ["sh", "/opt/system/germ/scripts/entrypoint.sh"]
CMD []
