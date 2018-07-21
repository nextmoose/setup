FROM fedora:28
RUN dnf update --assumeyes && dnf install --assumeyes cronie sudo docker && adduser user && echo "user ALL(ALL)=ALL NOPASSWD /usr/bin/crond" > /etc/sudoers.d/cronie && chmod 0444 /etc/sudoers.d/cronie && dnf clean all
COPY entrypoint.sh /entrypoint.sh
USER user
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD [""]
