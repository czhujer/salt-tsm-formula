{% if grains.osarch == "x86_64" %}

tsm_client_centos_u4:
  pkg.removed:
    - names:
        - TIVsm-msg.CS_CZ
    - require:
      - file: /etc/init.d/tivoli.sh_absent

{% elif czech_support == true %}

tsm_client_centos_u5:
  pkg.removed:
    - names:
        - TIVsm-msg_6.2.4
    - require:
      - file: /etc/init.d/tivoli.sh_absent

{% endif %}

{% if grains.osarch == "x86_64" %}

tsm_client_centos_pkg_u1:
  pkg.removed:
    - named:
      - gskcrypt64
      - gskssl64
      - TIVsm-BA
      - TIVsm-API64-6.3.0-15
    - require:
      - pkg: tsm_client_centos_u4

tsm_client_centos_pkg_u2:
  pkg.removed:
    - names:
      - glibc.i686
      - nss-softokn-freebl.i686
    - require:
      - pkg: tsm_client_centos_pkg_u1

{% else %}

tsm_client_centos_pkg_u3:
  pkg.removed:
    - names:
        - gskcrypt32
        - gskssl32
        - TIVsm-BA
        - TIVsm-API
    - require:
      - pkg: tsm_client_centos_u5

{% endif %}
