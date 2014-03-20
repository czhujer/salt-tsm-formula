
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

include:
- tsm.client-pkg-i-centos

- tsm.client-common

{# END OF CENTOS PART #}
{% elif grains.osfullname in ['CentOS'] and grains.osrelease in ['12.04'] and grains.osarch == "amd64" %}
{# 
#   UBUNTU PART
#}

include:
- tsm.client-pkg-i-ubuntu

- tsm.client-common

{%- else %}
{# 
#   NON-SUPPORT OS
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
