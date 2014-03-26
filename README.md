
# TSM

....

## Sample pillars

    tsm:
      client:
        enabled: true
        default_runlevel: 3
        name: tsm_client_name
        password: tsm_client_pass
        server:
          host: 10.0.0.xx
          port: 1500

## Sample pillar with czech language

    tsm:
      client:
        enabled: true
        name: tsm_client_name
        password: tsm_client_pass
        czech_support: true
        server:
          host: 10.0.0.xx
          port: 1500

## Sample pillar with custom logging

    tsm:
      client:
        enabled: true
        name: tsm_client_name
        password: tsm_client_pass
        logging: syslog
        server:
          host: 10.0.0.xx
          port: 1500

## Read more

## Issues

* part "cmd.run ldconfig" is executed every time on Ubuntu 12.04

* switching variable (czech_support) "enable to disable" does nothing (= with out enable/disable all state)

* -script "tsmc_fill_login.sh" does not work-

