# EFK Stack


## fluentd
Das compose file baut eine neues Fluentd Image aus dem `stable-debian-onbuild` Image und installiert das `elasticsearch`, `concat` und `grok` gem

Neue Logfiles können in das `./logs/input` directory gelegt werden. Fluentd configs werden in `./configs/fluentd/conf.d` abgelegt und in der `fluent.conf` nur included.

## elasticsearch

Der elasticsearch Container wird aus dem `elasticsearch-premium` image erstellt und hat alle x-pack features enabled. Audit logs sind allerdings disabled.

### x-pack (setup)

Seit 6.x sind die default Passwörter für elastic, kibana und logstash nicht gesetzt. Das Passwort des elastic superuser Accounts wird über die ENV vars in compose file auf `elastic` gesetzt.
Um mit Kibana, fluentd und einem eigenen User arbeiten zü können, muss das Script `./setup/es.sh` aufgerufen werden.

```bash
./setup/es.sh -u username -p password -e user@mail.foo
```

Der fluentd Account hat nur das Recht Indices zu erstellen, zu beschreiben und in Indices Dokumente anzulegen.

- create_inedx
- index

Siehe [Security Privileges](https://www.elastic.co/guide/en/x-pack/current/security-privileges.html)
