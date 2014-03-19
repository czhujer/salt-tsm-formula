{%- set default_runlevel = pillar.tsm.client.get('default_runlevel', 3) %}

{#
#   CENTOS AND UBUNTU PART
#}

/etc/init.d/tivoli.sh:
  file.managed:
  - source: salt://tsm/conf/tivoli.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755
{% if grains.osarch == "x86_64" %}
  - require:
    - pkg: tsm_client_centos_pkg_i2
{% else %}
  - require:
    - pkg: tsm_client_centos_pkg_i3
{% endif %}

/etc/rc{{ default_runlevel }}.d/S99tivoli:
  file.symlink:
    - target: /etc/init.d/tivoli.sh
    - require:
      - file: /etc/init.d/tivoli.sh

/opt/tivoli/tsm/client/ba/bin/dsm.opt:
  file.managed:
  - source: salt://tsm/conf/dsm.opt
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - require:
    - file: /etc/init.d/tivoli.sh

/opt/tivoli/tsm/client/ba/bin/dsm.sys:
  file.managed:
  - source: salt://tsm/conf/dsm.sys
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - require:
    - file: /etc/init.d/tivoli.sh

tsm_client_download_login_script_pre:
  file.absent:
    - name: /root/tsmc_fill_login.sh
    - require:
      - file: /opt/tivoli/tsm/client/ba/bin/dsm.sys
      - file: /opt/tivoli/tsm/client/ba/bin/dsm.opt

tsm_client_download_login_script:
  cmd.run:
    - name: wget https://vpc-admin.cloudlab.cz/public/tsmc_fill_login.sh --no-check-certificate
    - unless: "timeout 10 /opt/tivoli/tsm/client/ba/bin/dsmc q ses;"
    - require:
      - file: tsm_client_download_login_script_pre

tsm_client_install:
  cmd.run:
    - cwd: /root
    - name: bash /root/tsmc_fill_login.sh
    - unless: "timeout 10 /opt/tivoli/tsm/client/ba/bin/dsmc q ses;"
    - require:
      - cmd: tsm_client_download_login_script

tsm_client_login_script_absent:
  file.absent:
    - name: /root/tsmc_fill_login.sh
    - require:
      - cmd: tsm_client_install

tsm_client_service:
  service.running:
  - name: tivoli.sh
  - watch:
    - file: /etc/init.d/tivoli.sh
    - file: /etc/rc{{ default_runlevel }}.d/S99tivoli
    - file: /opt/tivoli/tsm/client/ba/bin/dsm.sys
    - file: /opt/tivoli/tsm/client/ba/bin/dsm.opt
    - cmd: tsm_client_install
