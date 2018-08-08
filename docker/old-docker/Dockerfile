FROM fedora:28
RUN dnf update --assumeyes && dnf install --assumeyes docker && dnf clean all
COPY entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD []