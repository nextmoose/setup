FROM fedora:28
COPY root /opt/system/germ/
RUN ["sh", "/opt/system/germ/scripts/run.sh"]
# USER user
WORKDIR /home/user/
ENTRYPOINT ["sh", "/opt/system/germ/scripts/entrypoint.sh"]
CMD []
