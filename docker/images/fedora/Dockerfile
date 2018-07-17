FROM fedora:28
RUN dnf update --assumeyes && dnf install --assumeyes docker sudo gpg pass && adduser user && dnf clean all
COPY entrypoint.sh /entrypoint.sh
USER user
WORKDIR /home/user/
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD []
