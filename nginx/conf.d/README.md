# Nginx Configuration Directory

This directory contains Nginx reverse proxy configurations for Community Hub services.

## Configuration Files

The `.conf` files in this directory are **not tracked by git** because they contain site-specific domain names and settings.

## Setup Instructions

1. Copy the example configurations from the documentation
2. Modify the `server_name` directives to match your domains
3. Adjust proxy settings as needed
4. Restart Nginx: `docker-compose restart nginx`

## Services Configuration

Each service should have a configuration file with:
- Upstream definition
- Internal domain (e.g., `portal.local`)
- Public domain (e.g., `portal.yourdomain.com`)
- Proxy headers and settings

## Example Structure

```nginx
upstream service_name {
    server container_name:port;
}

server {
    listen 80;
    server_name service.local;

    location / {
        proxy_pass http://service_name;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## See Also

- [Main Documentation](../../README.md)
- [Services Documentation](../../SERVICES.md)
