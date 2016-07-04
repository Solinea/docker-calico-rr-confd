Confd Config for Calico BIRD Route Reflector
===

* `latest`, `0.1`

Calico confd and templated configurations for a BIRD Route Reflector.

## Running

Start the BIRD container.

`docker run solinea/bird`

`docker run heidecke/bird-confd http://ETCD_HOST:ETCD_PORT`

For example: `docker run heidecke/bird-confd http://127.0.0.1:2379`

