# nginx-oqs

This docker container provides an Nginx server with Open Quantum Safe (OQS) support.

## Usage

Below is a basic `docker-compose.yml` example to get you started:

```yaml
services:
  nginx:
    image: ghcr.io/printfn/nginx-oqs:latest
    command: [nginx, '-g', 'daemon off;']
    ports:
      - "0.0.0.0:80:80"
      - "0.0.0.0:443:443"
      - "0.0.0.0:443:443/udp"
    volumes:
      - /path/to/your/nginx/conf/:/etc/nginx/:ro
      - /etc/letsencrypt:/etc/letsencrypt:ro
```

## Nginx Configuration

In your nginx config file you will want to set something like:

```nginx
events {
  worker_connections 1024;
}

http {
  http3_stream_buffer_size 1m;
  quic_retry on;
  ssl_early_data on;
  quic_gso on;
  quic_host_key /etc/nginx/ssl/quic_host.key;
  ssl_protocols TLSv1.3;

  server {
    listen 0.0.0.0:443 quic reuseport;
    listen 0.0.0.0:443 ssl;
    server_name example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;
    ssl_session_timeout 5m;
    ssl_session_cache shared:SSL:1m;
    ssl_session_tickets off;

    ssl_protocols TLSv1.3;
    ssl_ecdh_curve X25519MLKEM768:X25519;
    ssl_prefer_server_ciphers off;

    http2 on;
    http3 on;

    add_header Alt-Svc 'h3=":443"; ma=86400, h3-29=":443"; ma=86400' always;

    location / {
      add_header Alt-Svc 'h3=":443"; ma=86400, h3-29=":443"; ma=86400' always;
    }
  }
}
```

## Testing

Use `curl` like so:

```sh
curl -v --curves X25519MLKEM768 https://example.com
```

## Links

- [Open Quantum Safe](https://openquantumsafe.org/)
- [Nginx](https://nginx.org/)
