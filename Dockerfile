FROM fedora:rawhide
RUN dnf -y install patch vim nginx oqsprovider
RUN cat <<EOF >patch.diff
--- /etc/pki/tls/openssl.cnf.old
+++ /etc/pki/tls/openssl.cnf
@@ -63,11 +63,15 @@

 [provider_sect]
 default = default_sect
+oqsprovider = oqsprovider_sect
 ##legacy = legacy_sect
 ##
 [default_sect]
 activate = 1

+[oqsprovider_sect]
+activate = 1
+
 ##[legacy_sect]
 ##activate = 1

EOF
RUN patch /etc/pki/tls/openssl.cnf <patch.diff
EXPOSE 80 443 443/udp
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

# test with:
# curl -v --curves X25519MLKEM768 https://google.com
