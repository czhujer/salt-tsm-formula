{%- set czech_support = pillar.tsm.client.get('czech_support', false) %}

{# New in version Helium

tsm_client_ubuntu_update:
  pkg.uptodate:
    - refresh: true
#}

tsm_client_ubuntu_pkg_u3:
  pkg.removed:
    - names:
      - tivsm-api64
      - tivsm-ba
    - require:
      - file: /etc/init.d/tivoli.sh_absent

tsm_client_ubuntu_pkg_u2:
  pkg.removed:
    - names:
      - gskcrypt64
      - gskssl64
    - require:
      - pkg: tsm_client_ubuntu_pkg_u3

{#
autoremove ...
tsm_client_ubuntu_pkg_i1:
  pkg.installed:
    - names:
      - alien
      - libstdc++6
      - ksh
      - ia32-libs
#}
{#
    - require:
      - pkg: tsm_client_ubuntu_update
#}
