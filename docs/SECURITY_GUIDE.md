# Security Guide for CivicTechWR Projects

Security is critical for civic technology projects that serve community members and handle public data. This guide provides security best practices for CTWR projects.

## 🚀 Quick Start: Security in 5 Minutes

**New to civic tech security?** Start here for essential security basics:

### 1. Essential Security Checklist (Week 1-3)

- [ ] Read this overview section
- [ ] Set up HTTPS for your project
- [ ] Never commit passwords, API keys, or secrets to Git
- [ ] Use environment variables for sensitive configuration
- [ ] Enable basic input validation on all user inputs

### 2. Development Security (Week 4-9)

- [ ] Review [Secure Development Practices](#secure-development-practices)
- [ ] Implement authentication if handling user data
- [ ] Follow [Data Protection](#data-protection) guidelines
- [ ] Set up automated security scanning

### 3. Deployment Security (Week 10-12)

- [ ] Configure security headers
- [ ] Set up monitoring and logging
- [ ] Review [Infrastructure Security](#infrastructure-security)
- [ ] Create incident response plan

### When to Prioritize Security

- **High Priority**: Handling personal information, government data, or financial data
- **Medium Priority**: Public-facing tools with user accounts
- **Lower Priority**: Static websites or internal tools (but still follow basics)

## 📋 Common Security Mistakes to Avoid

1. **Hardcoded secrets** - Never put passwords in code
2. **Missing HTTPS** - Always encrypt data in transit
3. **No input validation** - Validate all user inputs
4. **Overpermissive access** - Grant minimum necessary permissions
5. **No backup/recovery plan** - Plan for when things go wrong

---

## Security Principles

### 1. Privacy by Design

- **Minimize data collection** - Only collect what's absolutely necessary
- **Anonymize data** where possible
- **Clear data retention policies** - Delete data when no longer needed
- **User consent** - Clear opt-in for any data collection

### 2. Defense in Depth

- **Multiple security layers** - Don't rely on single security measures
- **Fail securely** - When systems fail, they should fail safely
- **Principle of least privilege** - Grant minimum necessary access
- **Security throughout development** - Not just at the end

### 3. Transparency and Accountability

- **Open source security** - Security through transparency
- **Clear incident response** - Plan for when things go wrong
- **Regular security reviews** - Ongoing security assessment
- **Community reporting** - Safe ways to report security issues

## Secure Development Practices

### Code Security

#### Input Validation

```javascript
// Good: Validate and sanitize all inputs
function validateEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    throw new Error('Invalid email format');
  }
  return email.trim().toLowerCase();
}

// Good: Sanitize HTML content
function sanitizeHTML(content) {
  return content
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;');
}
```

#### SQL Injection Prevention

```python
# Good: Use parameterized queries
def get_user_data(user_id):
    query = "SELECT * FROM users WHERE id = %s"
    cursor.execute(query, (user_id,))
    return cursor.fetchone()

# Bad: String concatenation (vulnerable to SQL injection)
# query = f"SELECT * FROM users WHERE id = {user_id}"
```

#### Cross-Site Scripting (XSS) Prevention

```javascript
// Good: Escape output and validate input
function displayUserContent(content) {
  const sanitized = escapeHTML(content);
  document.getElementById('content').textContent = sanitized;
}

// Good: Use Content Security Policy
// Add to HTML head:
// <meta http-equiv="Content-Security-Policy" content="default-src 'self'">
```

### Authentication and Authorization

#### Password Security

```python
# Good: Hash passwords with salt
import bcrypt

def hash_password(password):
    salt = bcrypt.gensalt()
    return bcrypt.hashpw(password.encode('utf-8'), salt)

def verify_password(password, hashed):
    return bcrypt.checkpw(password.encode('utf-8'), hashed)
```

#### Session Management

```javascript
// Good: Secure session configuration
app.use(session({
  secret: process.env.SESSION_SECRET, // Use environment variable
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: true,      // HTTPS only
    httpOnly: true,    // No client-side access
    maxAge: 1800000,   // 30 minutes
    sameSite: 'strict' // CSRF protection
  }
}));
```

#### API Security

```javascript
// Good: Rate limiting
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP'
});

app.use('/api/', limiter);

// Good: API key validation
function validateApiKey(req, res, next) {
  const apiKey = req.headers['x-api-key'];
  if (!apiKey || !isValidApiKey(apiKey)) {
    return res.status(401).json({ error: 'Invalid API key' });
  }
  next();
}
```

## Environment and Configuration Security

### Environment Variables

```bash
# .env.example - Never commit actual .env files
# Database configuration
DATABASE_URL=postgresql://localhost:5432/your_db_name
DATABASE_PASSWORD=your_secure_password_here

# API keys (never commit real keys)
EXTERNAL_API_KEY=your_api_key_here
SESSION_SECRET=your_session_secret_here

# Security settings
HTTPS_ENABLED=true
CSRF_SECRET=your_csrf_secret_here
```

### Configuration Security

```javascript
// Good: Validate configuration
const config = {
  port: process.env.PORT || 3000,
  dbUrl: process.env.DATABASE_URL || (() => {
    throw new Error('DATABASE_URL environment variable required');
  })(),
  apiKey: process.env.API_KEY || (() => {
    throw new Error('API_KEY environment variable required');
  })(),
  // Force HTTPS in production
  httpsEnabled: process.env.NODE_ENV === 'production'
};

// Good: Security headers
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000');
  next();
});
```

## Data Protection

### Personal Information Handling

```python
# Good: Data minimization and anonymization
class UserData:
    def __init__(self, email, name, location=None):
        self.email_hash = self.hash_email(email)  # Store hash, not email
        self.name = name
        self.location_region = self.generalize_location(location)  # Region only

    def hash_email(self, email):
        return hashlib.sha256(email.encode()).hexdigest()

    def generalize_location(self, location):
        # Return region/city instead of full address
        if location:
            return location.split(',')[0]  # Just city/region
        return None
```

### Secure File Handling

```javascript
// Good: Validate file uploads
const multer = require('multer');
const path = require('path');

const upload = multer({
  dest: 'uploads/',
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB limit
  },
  fileFilter: (req, file, cb) => {
    const allowedTypes = ['image/jpeg', 'image/png', 'application/pdf'];
    if (allowedTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type'), false);
    }
  }
});

// Good: Scan uploaded files
function scanUploadedFile(filePath) {
  // Use virus scanning service
  // Validate file contents match extension
  // Check for malicious content
}
```

## Infrastructure Security

### HTTPS and TLS

```nginx
# nginx configuration for HTTPS
server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /path/to/certificate.crt;
    ssl_certificate_key /path/to/private.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512;

    # Security headers
    add_header Strict-Transport-Security "max-age=31536000" always;
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options DENY;
}
```

### Database Security

```sql
-- Good: Create limited-privilege database user
CREATE USER app_user WITH PASSWORD 'secure_random_password';
GRANT SELECT, INSERT, UPDATE ON app_tables TO app_user;
-- Don't grant unnecessary privileges like DROP, CREATE

-- Good: Use database connection encryption
-- Connection string: postgresql://user:pass@host:5432/db?sslmode=require
```

### Container Security

```dockerfile
# Good: Use specific, non-root user
FROM node:18-alpine
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodeuser -u 1001
USER nodeuser

# Good: Don't include unnecessary packages
# Use alpine images when possible
# Scan images for vulnerabilities regularly
```

## Civic Tech Specific Security

### Government Data Handling

- **Classification awareness** - Understand data sensitivity levels
- **Compliance requirements** - Follow local privacy laws (PIPEDA, GDPR)
- **Audit trails** - Log access to sensitive government data
- **Retention policies** - Follow government data retention rules

### Community Data Protection

```python
# Good: Protect community member data
class CommunityDataHandler:
    def store_feedback(self, feedback_text, user_location=None):
        # Remove personally identifiable information
        anonymous_feedback = self.anonymize_text(feedback_text)

        # Generalize location to protect privacy
        general_location = self.generalize_location(user_location)

        return {
            'feedback': anonymous_feedback,
            'region': general_location,
            'timestamp': datetime.utcnow(),
            'id': self.generate_anonymous_id()
        }

    def anonymize_text(self, text):
        # Remove names, phone numbers, addresses
        patterns = [
            r'\b\d{3}-\d{3}-\d{4}\b',  # Phone numbers
            r'\b\d+\s+\w+\s+(street|st|avenue|ave|road|rd)\b',  # Addresses
        ]
        for pattern in patterns:
            text = re.sub(pattern, '[REDACTED]', text, flags=re.IGNORECASE)
        return text
```

### Partner Organization Security

- **Data sharing agreements** - Clear security requirements
- **Access controls** - Limit who can access what data
- **Regular security reviews** - Periodic assessment of partner security
- **Incident response coordination** - Joint response plans

## Security Testing

### Static Analysis

```yaml
# .github/workflows/security.yml
name: Security Scan

on: [push, pull_request]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run security scan
        uses: securecodewarrior/github-action-add-sarif@v1
        with:
          sarif-file: security-scan-results.sarif

      - name: Check for vulnerable dependencies
        run: npm audit --audit-level high
```

### Penetration Testing Checklist

- [ ] **Authentication bypass** - Try to access protected resources
- [ ] **Authorization flaws** - Test role-based access controls
- [ ] **Input validation** - Test with malicious inputs
- [ ] **Session management** - Test session fixation, hijacking
- [ ] **Error handling** - Ensure errors don't leak sensitive info
- [ ] **Business logic flaws** - Test application-specific logic

### Security Code Review

```markdown
## Security Review Checklist

### Input Validation
- [ ] All user inputs are validated
- [ ] SQL injection prevention implemented
- [ ] XSS prevention measures in place
- [ ] File upload restrictions configured

### Authentication & Authorization
- [ ] Strong password requirements
- [ ] Secure session management
- [ ] Proper access controls
- [ ] Multi-factor authentication (if applicable)

### Data Protection
- [ ] Sensitive data encrypted in transit
- [ ] Sensitive data encrypted at rest
- [ ] PII handling follows privacy laws
- [ ] Data retention policies implemented

### Infrastructure
- [ ] HTTPS enforced
- [ ] Security headers configured
- [ ] Error pages don't leak information
- [ ] Logging captures security events
```

## Incident Response

### Security Incident Plan

1. **Detection** - How to identify security incidents
2. **Containment** - Steps to limit damage
3. **Investigation** - How to understand what happened
4. **Recovery** - Steps to restore normal operations
5. **Lessons Learned** - How to prevent future incidents

### Incident Response Template

```markdown
## Security Incident Report

**Date/Time:** [When incident was detected]
**Severity:** [Low/Medium/High/Critical]
**Type:** [Data breach, unauthorized access, etc.]

### Summary
[Brief description of what happened]

### Impact Assessment
- **Data affected:** [What data was compromised]
- **Users affected:** [How many/which users]
- **Systems affected:** [Which systems were impacted]

### Timeline
- [Time]: [Event description]
- [Time]: [Event description]

### Response Actions
- [ ] [Action taken]
- [ ] [Action taken]

### Lessons Learned
[What can be improved for future incidents]
```

## Security Resources

### Tools and Libraries

#### Static Analysis Tools

- **JavaScript/Node.js:** ESLint security plugin, Snyk
- **Python:** Bandit, Safety
- **General:** SonarQube, CodeQL

#### Dependencies Management

```json
// package.json - Regular security updates
{
  "scripts": {
    "audit": "npm audit",
    "audit-fix": "npm audit fix",
    "security-check": "npx audit-ci --moderate"
  }
}
```

#### Monitoring and Logging

```javascript
// Good: Security event logging
const winston = require('winston');

const securityLogger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'security.log' })
  ]
});

function logSecurityEvent(event, user, details) {
  securityLogger.info({
    timestamp: new Date().toISOString(),
    event: event,
    user: user,
    details: details,
    ip: req.ip
  });
}
```

### Compliance and Standards

#### Canadian Privacy Laws

- **PIPEDA** - Personal Information Protection and Electronic Documents Act
- **Provincial privacy laws** - Ontario FIPPA, BC FOIPPA, etc.
- **Municipal requirements** - Local government privacy policies

#### International Standards

- **GDPR** - If serving EU residents
- **WCAG 2.1** - Accessibility standards
- **ISO 27001** - Information security management

### Emergency Contacts

#### Security Incident Contacts

- **CTWR Leadership:** [Contact information]
- **Partner Organizations:** [Emergency contacts]
- **Technical Team:** [On-call information]

#### External Resources

- **Canadian Cyber Incident Response Centre:** cyber.gc.ca
- **Provincial Privacy Commissioners:** [Local contact]
- **Legal Counsel:** [If needed for incidents]

## Security Checklist for CTWR Projects

### Project Setup

- [ ] Security requirements defined in project planning
- [ ] Threat model created for project
- [ ] Security testing integrated into development process
- [ ] Incident response plan created

### Development Phase

- [ ] Secure coding practices followed
- [ ] Security code reviews conducted
- [ ] Dependency security scanning automated
- [ ] Security testing performed

### Deployment Phase

- [ ] HTTPS configured and enforced
- [ ] Security headers implemented
- [ ] Access controls configured
- [ ] Monitoring and logging enabled

### Ongoing Maintenance

- [ ] Regular security updates applied
- [ ] Security monitoring in place
- [ ] Incident response plan tested
- [ ] Security training for team members

---

**🔒 Related Resources:**

- [Accessibility Guide](ACCESSIBILITY_GUIDE.md) - Security considerations for inclusive design
- [Contributing Guidelines](CONTRIBUTING.md) - Security requirements for contributors
- [Technical Design](TECHNICAL_DESIGN.md) - Security architecture decisions

**🔄 Last Updated:** [Date] by [@contributor]
**📅 Next Review:** [Date - recommend quarterly security review]
