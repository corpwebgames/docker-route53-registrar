Register Docker Containers on Route53
==============================

* Listen to start events of containers on the docker socket.
* Outputs a shell script with the list of expected A Records when a container has defined REQUEST_DNS_REGISTER environment variable.
* Execute the script to create or update the list of A Records with Route53.

[jwilder/docker-gen](https://github.com/jwilder/docker-gen) is in charge of listening to the docker events and generating the file.
[barnybug/cli53](https://github.com/barnybug/cli53) is in charge of talking to Route53.

Setup
=====

Environment variables:

* `AWS_ACCESS_KEY_ID` Required
* `AWS_SECRET_ACCESS_KEY` Required
* `RECORD_IP` The IP of the generated records. If not defined will use public IP.
* `RECORD_HOST`
* `USE_A_RECORD`
* `ZONE` Route53 zone name.
* `DRY_RUN` when defined, just echo the commands that we would run.

When `RECORD_IP` is not defined, call AWS's EC2 metadataservice to get it.
When AWS EC2 metadata service is not present; call icanhazip.com.

When the REQUEST_DNS_REGISTER is defined in a container, it will be registered on Route53.

Example run
===========
```
docker run --rm -ti --name route53 -v /var/run/docker.sock:/tmp/docker.sock:ro -e ZONE=staging.aws route53-registrar
```

Minimum IAM policy:
===================
```
{
  "Effect": "Allow",
  "Action": [
    "route53:ChangeResourceRecordSets",
    "route53:GetChange",
    "route53:GetHostedZone",
    "route53:ListResourceRecordSets"
  ],
  "Resource": "arn:aws:route53:::hostedzone/*"
},
{
  "Effect": "Allow",
  "Action": [
    "route53:ListHostedZones"
  ],
  "Resource": "*"
}
```

License
=======

Apache 2.0. See LICENSE for details
