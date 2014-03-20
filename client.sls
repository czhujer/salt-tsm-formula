
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
{% elif grains.osfullname in ['Ubuntu'] and grains.osrelease in ['12.04'] and grains.osarch == "amd64" %}
{# 
#   UBUNTU PART
#}

include:
- tsm.client-pkg-i-ubuntu

- tsm.client-ubuntu

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

include:
- tsm.client-common-r

- tsm.client-pkg-u-centos

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
