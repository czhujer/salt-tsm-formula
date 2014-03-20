/etc/ld.so.conf.d/tivoli.conf:
  file.managed:
  - source: salt://tsm/conf/ld.so.conf.d--tivoli.conf
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - require:
    - pkg: tsm_client_ubuntu_pkg_i3

/var/lock/subsys:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/usr/lib/libgpfs.so:
  file.symlink:
    - target: /opt/tivoli/tsm/client/api/bin64/libgpfs.so
    - require:
      - file: /var/lock/subsys

/usr/lib/libdmapi.so:
  file.symlink:
    - target: /opt/tivoli/tsm/client/api/bin64/libdmapi.so
    - require:
      - file: /var/lock/subsys

/usr/lib/libgsk8ssl_64.so:
  file.symlink:
    - target: /usr/local/ibm/gsk8_64/lib64/libgsk8ssl_64.so
    - require:
      - file: /var/lock/subsys

/usr/lib/libgsk8iccs_64.so:
  file.symlink:
    - target: /usr/local/ibm/gsk8_64/lib64/libgsk8iccs_64.so
    - require:
      - file: /var/lock/subsys

/usr/lib/libgsk8cms_64.so:
  file.symlink:
    - target: /usr/local/ibm/gsk8_64/lib64/libgsk8cms_64.so
    - require:
      - file: /var/lock/subsys

/usr/lib/libgsk8sys_64.so:
  file.symlink:
    - target: /usr/local/ibm/gsk8_64/lib64/libgsk8sys_64.so
    - require:
      - file: /var/lock/subsys

tsm_client_install_ldconfig:
  cmd.run:
  - name: ldconfig
  - watch:
    - file: /usr/lib/libgpfs.so
    - file: /usr/lib/libdmapi.so
    - file: /usr/lib/libgsk8ssl_64.so
    - file: /usr/lib/libgsk8iccs_64.so
    - file: /usr/lib/libgsk8cms_64.so
    - file: /usr/lib/libgsk8sys_64.so
