# Security Headers Configuration

Add these HTTP headers to all API responses for enhanced security:

## Required Headers

### Content Security Policy (CSP)
```
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline'; img-src 'self' https: data:; connect-src 'self' https:; font-src 'self' https:;
```

### HTTP Strict Transport Security (HSTS)
```
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

### X-Frame-Options (Clickjacking Protection)
```
X-Frame-Options: SAMEORIGIN
```

### X-Content-Type-Options (MIME Sniffing Protection)
```
X-Content-Type-Options: nosniff
```

### X-XSS-Protection
```
X-XSS-Protection: 1; mode=block
```

### Referrer-Policy
```
Referrer-Policy: strict-origin-when-cross-origin
```

## Supabase Configuration

Add these headers in `supabase/config.toml`:

```toml
[api]
jwt_expiry = 3600
jwt_default_group_name = "authenticated"
max_request_body_size = 20971520

[http]
# Add custom response headers
[[http.headers]]
name = "Content-Security-Policy"
value = "default-src 'self'; script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline'; img-src 'self' https: data:; connect-src 'self' https:; font-src 'self' https:;"

[[http.headers]]
name = "Strict-Transport-Security"
value = "max-age=31536000; includeSubDomains; preload"

[[http.headers]]
name = "X-Frame-Options"
value = "SAMEORIGIN"

[[http.headers]]
name = "X-Content-Type-Options"
value = "nosniff"
```

## Implementation Checklist

- [ ] Add CSP header to all API responses
- [ ] Enable HSTS with max-age at least 1 year
- [ ] Add X-Frame-Options to prevent clickjacking
- [ ] Add X-Content-Type-Options to prevent MIME sniffing
- [ ] Test headers with [securityheaders.com](https://securityheaders.com)
- [ ] Update CORS configuration to match security policy
