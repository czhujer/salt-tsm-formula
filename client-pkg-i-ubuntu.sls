{%- set czech_support = pillar.tsm.client.get('czech_support', false) %}

{# New in version Helium

tsm_client_ubuntu_update:
  pkg.uptodate:
    - refresh: true
#}

tsm_client_ubuntu_pkg_i1:
  pkg.installed:
    - names:
      - alien
      - libstdc++6
      - ksh
      - ia32-libs
{#
    - require:
      - pkg: tsm_client_ubuntu_update
#}

tsm_client_ubuntu_pkg_i2:
  pkg.installed:
    - sources:
      - gskcrypt64: salt://tsm/pkgs/Ubnt_12.4_x64/gskcrypt64-8.0.deb
      - gskssl64: salt://tsm/pkgs/Ubnt_12.4_x64/gskssl64-8.0.deb
    - require:
      - pkg: tsm_client_ubuntu_pkg_i1


tsm_client_ubuntu_pkg_i3:
  pkg.installed:
    - sources:
      - TIVsm-API64: salt://tsm/pkgs/Ubnt_12.4_x64/TIVsm-API64-6.3.1.deb
      - TIVsm-BA: salt://tsm/pkgs/Ubnt_12.4_x64/TIVsm-BA-6.3.1.deb
    - require:
      - pkg: tsm_client_ubuntu_pkg_i2

