FROM fedora:28
RUN dnf update --assumeyes && dnf install --assumeyes emacs* git openssh-clients && adduser user
COPY root /opt/
USER user
RUN mkdir /home/user/project && git -C /home/user/project init
WORKDIR /home/user/project
ENTRYPOINT ["sh", "/opt/scripts/entrypoint.sh"]
CMD []
