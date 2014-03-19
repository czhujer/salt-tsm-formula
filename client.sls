{%- set czech_support = pillar.tsm.client.get('czech_support', false) %}

{%- set default_runlevel = pillar.tsm.client.get('default_runlevel', 3) %}

{%- if pillar.tsm.client.enabled %}

{# 
##
#   TSM CLIENT ENABLED
##
#}

{%- if grains.osfullname in ['CentOS'] and grains.osrelease in ['6.3', '6.4', '6.5'] %}
{# 
#   CENTOS PACKAGE PART
#}

include:
- tsm.client-pkg-i-centos

{%- elif (grains.osfullname in ['CentOS'] and grains.osrelease in ['6.3', '6.4', '6.5']) or (grains.osfullname in ['Ubuntu']) %}

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

{# END OF CENTOS PART #}
{%- else %}
{# 
##
#   NON-SUPPORT OS
##
#}

cmd_unsupor_os:
  cmd.run:
    - name: echo -n "Error! Unsupported OS... " && cat /etc/issue |head -1

{# END OF OS ELSE PART #}
{%- endif %}

{# END OF piller.tsm.client.enabled #}
{% elif pillar.tsm.client.enable == false %}

{# 
##
#   TSM CLIENT DISABLED
##
#}

{%- if grains.osfullname in ['CentOS'] and grains.osrelease in ['6.3', '6.4', '6.5'] %}
{# 
#   CENTOS PART
#}

{% if grains.osarch == "x86_64" %}

tsm_client_centos_pkg_p1:
  pkg.removed:
    - names:
        - gskcrypt64
        - gskssl64
        - TIVsm-BA
        - TIVsm-API64

tsm_client_centos_pkg_p2:
  pkg.removed:
    - names:
        - glibc.i686
        - nss-softokn-freebl.i686
    - require:
        -pkg: tsm_client-centos_pkg_p1

{% else %}

tsm_client_centos_p3:
  pkg.removed:
    - names:
        - gskcrypt32
        - gskssl32
        - TIVsm-BA
        - TIVsm-API

{% endif %}

{% if grains.osarch == "x86_64" and czech_support == true %}

tsm_client_centos_packages4:
  pkg.removed:
    - names:
        - TIVsm-msg.CS_CZ

{% elif czech_support == true %}

tsm_client_centos_packages5:
  pkg.removed:
    - names:
        - TIVsm-msg_6.2.4.CS_CZ

{% endif %}

{# END OF CENTOS PART #}
{%- else %}
{# 
##
#   NON-SUPPORT OS
##
#}

cmd_unsupor_os:
  cmd.run:
    - name: echo -n "Error! Unsupported OS... " && cat /etc/issue |head -1

{# END OF OS ELSE PART #}
{%- endif %}

{# END OF elif piller.tsm.client.enabled == false #}
{% endif %}
