{%- if pillar.tsm.client.enabled %}

{% set tsm_version = '1.02.2' %}

{% if grains.kernel == 'Linux'  %}

tsm_client_packages:
  pkg.installed:
  - names:
    - wget

tsm_client_install:
  cmd.run:
  - name: wget http://10.0.110.14/MIRRORS/CloudLabPisek/tsmc/tsmc_lin_{{ tsm_version }}.tar
  - unless: "test -e /root/tsmc_lin_{{ tsm_version }}.tar"
  - require:
    - pkg: tsm_client_packages

{% endif %}

{% if grains.kernel == 'Windows'  %}

tsm_client_install:
  cmd.run:
  - name: wget http://10.0.110.14/MIRRORS/CloudLabPisek/tsmc/tsmc_lin_{{ tsm_version }}.tar
  - unless: "test -e /root/tsmc_lin_{{ tsm_version }}.tar"
  - require:
    - pkg: tsm_client_packages

{% endif %}

{% endif %}