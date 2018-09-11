FROM ubuntu:16.04
RUN \
    apt-get update --assume-yes && \
    	    apt-get install --assume-yes software-properties-common python-software-properties && \
	    apt-get update --assume-yes && \
    	    add-apt-repository ppa:jonathonf/pepperflashplugin-nonfree && \
	    apt-get update --assume-yes && \
	    apt-get install --assume-yes pepperflashplugin-nonfree && \
	    apt-get update --assume-yes && \
	    apt-get update --assume-yes chromium-browser && \
	    apt-get update --assume-yes && \
	    apt-get clean && \
	    adduser --disabled-password --gecos "" user &&
	    apt-get update --assume-yes && \
	    apt-get clean && \
	    true
USER user
ENTRYPOINT [ "chromium" ]
CMD []