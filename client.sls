{%- if pillar.tsm.client.enabled %}

{% set tsm_version = '1.02.2' %}

{% if grains.kernel == 'Linux'  %}

tsm_client_packages:
  pkg.installed:
  - names:
    - wget

tsm_client_install_dir:
  file.directory:
  - name: /root/tsmc_lin_{{ tsm_version }}

tsm_client_download:
  cmd.run:
  - name: wget http://10.0.110.14/MIRRORS/CloudLabPisek/tsmc/tsmc_lin_{{ tsm_version }}.tar
  - unless: "test -e /root/tsmc_lin_{{ tsm_version }}.tar"
  - require:
    - pkg: tsm_client_packages

tsm_client_untar:
  cmd.run:
  - name: tar -xvf tsmc_lin_{{ tsm_version }}.tar -C /root/tsmc_lin_{{ tsm_version }}
  - unless: "test -e /root/tsmc_lin_{{ tsm_version }}/tivoli.sh"
  - require:
    - pkg: tsm_client_packages
    - file: tsm_client_install_dir

{#
tsm_client_install:
  cmd.run:
  - name: wget http://10.0.110.14/MIRRORS/CloudLabPisek/tsmc/tsmc_lin_{{ tsm_version }}.tar
  - unless: "test -e /root/tsmc_lin_{{ tsm_version }}.tar"
  - require:
    - pkg: tsm_client_untar
#}

{% endif %}

{% if grains.kernel == 'Windows'  %}




{% endif %}

{% endif %}