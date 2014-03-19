{%- set czech_support = pillar.tsm.client.get('czech_support', false) %}

{%- if pillar.tsm.client.enabled %}

{# 
##
#   TSM CLIENT ENABLED
##
#}

{%- if grains.osfullname in ['CentOS'] and grains.osrelease in ['6.3', '6.4', '6.5'] %}
{# 
#   CENTOS PART
#}

{% if grains.osarch == "x86_64" %}

tsm_client_centos_pkg_i1:
  pkg.installed:
    - names:
      - glibc.i686
      - nss-softokn-freebl.i686

tsm_client_centos_pkg_i2:
  pkg.installed:
    - sources:
      - gskcrypt64: salt://tsm/pkgs/com64/gskcrypt64-8.0.14.11.linux.x86_64.rpm
      - gskssl64: salt://tsm/pkgs/com64/gskssl64-8.0.14.11.linux.x86_64.rpm
      - TIVsm-BA: salt://tsm/pkgs/com64/TIVsm-BA.x86_64.rpm
      - TIVsm-API64: salt://tsm/pkgs/com64/TIVsm-API64.x86_64.rpm
    - require:
      - pkg: tsm_client_centos_pkg_i1

{% else %}

tsm_client_centos_pkg_i3:
  pkg.installed:
    - sources:
        - gskcrypt32: salt://tsm/pkgs/linux86/gskcrypt32-8.0.14.6.linux.x86.rpm
        - gskssl32: salt://tsm/pkgs/linux86/gskssl32-8.0.14.6.linux.x86.rpm
        - TIVsm-BA: salt://tsm/pkgs/com64/TIVsm-BA.i686.rpm
        - TIVsm-API: salt://tsm/pkgs/com64/TIVsm-API64.i686.rpm

{% endif %}

{% if grains.osarch == "x86_64" and czech_support == true %}

tsm_client_centos_packages4:
  pkg.installed:
    - sources:
        -TIVsm-msg: salt://tsm/pkgs/com64/CSY/TIVsm-msg.CS_CZ.x86_64.rpm

{% elif czech_support == true %}

tsm_client_centos_packages5:
  pkg.installed:
    - sources:
        -TIVsm-msg_6.2.4: salt://tsm/pkgs/linux86/CSY/TIVsm-msg_6.2.4.CS_CZ.i386.rpm

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
