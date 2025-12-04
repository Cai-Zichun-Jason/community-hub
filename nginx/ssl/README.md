# SSL Certificates Directory

This directory is for SSL/TLS certificates.

## ⚠️ Security Notice

**All certificate files (`.key`, `.crt`, `.pem`, etc.) in this directory are ignored by git for security reasons.**

## Setup Instructions

### Option 1: Let's Encrypt (Recommended for Public Domains)

```bash
# Install Certbot
sudo apt install certbot

# Obtain certificates
sudo certbot certonly --standalone -d yourdomain.com

# Copy certificates to this directory
sudo cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem ./
sudo cp /etc/letsencrypt/live/yourdomain.com/privkey.pem ./
```

### Option 2: Self-Signed Certificate (Development/Internal Use)

```bash
# Generate self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ./selfsigned.key \
  -out ./selfsigned.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=yourdomain.local"
```

### Option 3: Existing Certificates

Copy your existing certificate files to this directory:
- Certificate: `cert.crt` or `cert.pem`
- Private key: `cert.key` or `privkey.pem`
- CA bundle (optional): `ca-bundle.crt`

## Nginx Configuration

Update your Nginx configuration in `../conf.d/*.conf`:

```nginx
server {
    listen 443 ssl;
    server_name yourdomain.com;

    ssl_certificate /etc/nginx/ssl/cert.crt;
    ssl_certificate_key /etc/nginx/ssl/cert.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # ... rest of your configuration
}
```

## File Permissions

Ensure proper permissions for security:

```bash
chmod 600 *.key
chmod 644 *.crt *.pem
```

## Certificate Renewal

For Let's Encrypt certificates, set up auto-renewal:

```bash
# Test renewal
sudo certbot renew --dry-run

# Add to crontab for automatic renewal
0 3 * * * certbot renew --quiet && docker-compose restart nginx
```
