{%- set default_runlevel = pillar.tsm.client.get('default_runlevel', 3) %}

{#
#   CENTOS AND UBUNTU PART
#}

tsm_client_service_stop:
  cmd.run:
  - name: pidof dsmcad | { read dsm_pid; kill $dsm_pid; }
  - unless: "pidof dsmcad"

/etc/rc{{ default_runlevel }}.d/S99tivoli_absent:
  file.absent:
    - name: /etc/rc{{ default_runlevel }}.d/S99tivoli
{#    - require:
      - service: tsm_client_service_stop
#}

/etc/init.d/tivoli.sh_absent:
  file.absent:
    - name: /etc/init.d/tivoli.sh
    - require:
      - file: /etc/rc{{ default_runlevel }}.d/S99tivoli_absent


{#
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
#}
