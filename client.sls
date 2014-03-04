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

/root/tsmc_lin_{{ tsm_version }}/dsm_gen.sys:
  file.managed:
  - user: root
  - group: root
  - source: salt://tsm/conf/dsm_gen.sys
  - mode: 755
  - template: jinja
  - require:
    - cmd: tsm_client_untar

/root/tsmc_lin_{{ tsm_version }}/ispc_install.sh:
  file.managed:
  - user: root
  - group: root
  - source: salt://tsm/conf/ispc_install.sh
  - mode: 755
  - template: jinja
  - require:
    - cmd: tsm_client_untar

tsm_client_install:
  cmd.run:
  - cwd: /root/tsmc_lin_{{ tsm_version }}
  - name: ./ispc_install.sh {{ pillar.tsm.client.name }}
  - unless: "test -e /opt/tivoli"
  - require:
    - file: /root/tsmc_lin_{{ tsm_version }}/ispc_install.sh

{% endif %}

{% if grains.kernel == 'Windows'  %}

{% endif %}

{% endif %}