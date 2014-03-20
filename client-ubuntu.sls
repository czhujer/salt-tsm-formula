/etc/ld.so.conf.d/tivoli.conf:
  file.managed:
  - source: salt://tsm/conf/ld.so.conf.d--tivoli.conf
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - require:
    - pkg: tsm_client_ubuntu_pkg_i3

mkdir /var/lock/subsys

ln -s /opt/tivoli/tsm/client/api/bin64/libgpfs.so /usr/lib/libgpfs.so
ln -s /opt/tivoli/tsm/client/api/bin64/libdmapi.so /usr/lib/libdmapi.so
ln -s /usr/local/ibm/gsk8_64/lib64/libgsk8ssl_64.so  /usr/lib/libgsk8ssl_64.so
ln -s /usr/local/ibm/gsk8_64/lib64/libgsk8iccs_64.so /usr/lib/libgsk8iccs_64.so
ln -s /usr/local/ibm/gsk8_64/lib64/libgsk8cms_64.so  /usr/lib/libgsk8cms_64.so
ln -s /usr/local/ibm/gsk8_64/lib64/libgsk8sys_64.so /usr/lib/libgsk8sys_64.so

ldconfig

