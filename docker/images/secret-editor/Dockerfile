FROM fedora:28
RUN while ! dnf update --assumeyes; do echo FUCK; done
RUN dnf install --assumeyes tree
RUN dnf install --assumeyes gnupg
RUN dnf install --assumeyes pass
RUN dnf install --assumeyes findutils
RUN dnf install --assumeyes git
RUN dnf install --assumeyes openssh-clients
RUN adduser user
COPY entrypoint.sh post-commit.sh /
USER user
RUN mkdir ${HOME}/.ssh && chmod 0700 ${HOME}/.ssh
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD []
