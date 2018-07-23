FROM fedora:28
COPY root /opt/system/
RUN ["sh", "/opt/system/primary/run.root.primary.sh"]
ONBUILD COPY root /opt/system/
ONBUILD RUN ["sh", "/opt/system/primary/run.root.secondary.sh"]
ENTRYPOINT ["sh", "/opt/system/primary/entrypoint.root.sh"]
CMD []
