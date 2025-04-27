FROM fedora:rawhide
RUN dnf -y install nginx
EXPOSE 80 443 443/udp
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

# test with:
# curl -v --curves X25519MLKEM768 https://google.com
