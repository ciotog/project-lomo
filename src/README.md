# Source Code Directory

This directory contains the main source code for your CivicTechWR project.

## Directory Structure

Organize your code based on your project's technology stack:

### For Web Applications

```text
src/
├── components/          # Reusable UI components
├── pages/              # Page-level components
├── services/           # API calls and data services
├── utils/              # Helper functions
├── styles/             # CSS/styling files
├── assets/             # Images, fonts, etc.
├── hooks/              # Custom React hooks (if using React)
├── context/            # State management
└── __tests__/          # Component tests
```

### For Python Applications

```text
src/
├── models/             # Data models
├── views/              # View logic
├── services/           # Business logic
├── utils/              # Helper functions
├── templates/          # HTML templates
├── static/             # CSS, JS, images
├── migrations/         # Database migrations
└── tests/              # Unit tests
```

### For Mobile Applications (Flutter)

```text
src/
├── screens/            # App screens
├── widgets/            # Reusable widgets
├── models/             # Data models
├── services/           # API and data services
├── utils/              # Helper functions
├── themes/             # App styling
└── tests/              # Widget and unit tests
```

## Coding Standards

### General Principles

- **Write readable code** - Use clear variable and function names
- **Comment complex logic** - Help future contributors understand your code
- **Follow accessibility best practices** - Ensure your code works for everyone
- **Secure by default** - Don't expose sensitive data or create vulnerabilities

### File Naming

- Use lowercase with hyphens for files: `user-profile.js`
- Use PascalCase for React components: `UserProfile.jsx`
- Use snake_case for Python files: `user_profile.py`

### Code Organization

- Keep files small and focused on a single responsibility
- Group related functionality together
- Use consistent import/export patterns
- Add proper error handling

### Documentation

- Document public APIs and complex functions
- Include examples in your documentation
- Keep README files up to date
- Document any civic tech specific considerations

## Technology-Specific Guidelines

### JavaScript/TypeScript

```javascript
// Good: Clear function names and JSDoc comments
/**
 * Calculates the distance between two geographic points
 * @param {number} lat1 - Latitude of first point
 * @param {number} lon1 - Longitude of first point
 * @param {number} lat2 - Latitude of second point
 * @param {number} lon2 - Longitude of second point
 * @returns {number} Distance in kilometers
 */
function calculateDistance(lat1, lon1, lat2, lon2) {
  // Implementation here
}

// Good: Accessible React component
function AccessibleButton({ onClick, children, ...props }) {
  return (
    <button
      onClick={onClick}
      type="button"
      className="btn"
      {...props}
    >
      {children}
    </button>
  );
}
```

### Python

```python
# Good: Clear docstrings and type hints
from typing import List, Optional

def filter_public_data(records: List[dict],
                      privacy_level: str = 'public') -> List[dict]:
    """
    Filter records to only include public information.

    Args:
        records: List of data records to filter
        privacy_level: Privacy level to filter by ('public', 'internal')

    Returns:
        List of filtered records with only public data
    """
    # Implementation here
    pass

# Good: Error handling for external APIs
def fetch_city_data(endpoint: str) -> Optional[dict]:
    """Fetch data from city API with proper error handling."""
    try:
        response = requests.get(endpoint, timeout=10)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        logger.error(f"Failed to fetch city data: {e}")
        return None
```

## Security Guidelines

### Data Protection

- Never commit API keys, passwords, or secrets
- Use environment variables for sensitive configuration
- Validate all user input
- Use HTTPS for all external communications

### Privacy Considerations

- Minimize data collection to what's necessary
- Anonymize or pseudonymize personal data
- Implement proper data retention policies
- Follow GDPR and privacy best practices

### Example: Secure configuration

```javascript
// Good: Using environment variables
const config = {
  apiUrl: process.env.REACT_APP_API_URL,
  publicKey: process.env.REACT_APP_PUBLIC_KEY,
  // Never put secrets in client-side code!
};

// Good: Input validation
function validateEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}
```

## Testing Guidelines

### Test Structure

```text
__tests__/
├── components/         # Component tests
├── services/          # Service/API tests
├── utils/             # Utility function tests
├── integration/       # Integration tests
└── accessibility/     # Accessibility tests
```

### Testing Best Practices

- Write tests for all public functions
- Test error conditions and edge cases
- Include accessibility tests
- Test with real data when possible

### Example Tests

```javascript
// Good: Component test with accessibility
import { render, screen } from '@testing-library/react';
import { axe, toHaveNoViolations } from 'jest-axe';
import UserProfile from '../UserProfile';

expect.extend(toHaveNoViolations);

test('UserProfile renders correctly and is accessible', async () => {
  const user = { name: 'John Doe', email: 'john@example.com' };
  const { container } = render(<UserProfile user={user} />);

  expect(screen.getByText('John Doe')).toBeInTheDocument();

  // Accessibility test
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

## Getting Started

1. **Set up your development environment** using `./scripts/setup.sh`
2. **Choose appropriate directory structure** based on your tech stack
3. **Install linting and formatting tools** for code quality
4. **Set up testing framework** for your chosen technology
5. **Configure accessibility testing** tools

## Code Review Guidelines

When reviewing code, check for:

- [ ] Code follows project conventions
- [ ] Functions are well-documented
- [ ] Security best practices are followed
- [ ] Accessibility standards are met
- [ ] Tests are included for new functionality
- [ ] No sensitive data is exposed

## Common Patterns for Civic Tech

### API Integration

```javascript
// Good: Robust API service for civic data
class CivicDataService {
  constructor(baseUrl, apiKey) {
    this.baseUrl = baseUrl;
    this.apiKey = apiKey;
  }

  async getPublicData(endpoint, options = {}) {
    try {
      const response = await fetch(`${this.baseUrl}/${endpoint}`, {
        headers: {
          'Authorization': `Bearer ${this.apiKey}`,
          'Content-Type': 'application/json',
        },
        ...options,
      });

      if (!response.ok) {
        throw new Error(`API Error: ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      console.error('Failed to fetch civic data:', error);
      throw error;
    }
  }
}
```

### Data Visualization

```javascript
// Good: Accessible chart component
function AccessibleChart({ data, title, description }) {
  return (
    <div role="img" aria-labelledby="chart-title" aria-describedby="chart-desc">
      <h3 id="chart-title">{title}</h3>
      <p id="chart-desc">{description}</p>
      <div className="chart-container">
        {/* Chart implementation */}
      </div>
      {/* Provide data table alternative */}
      <table className="sr-only">
        <caption>Data table alternative for {title}</caption>
        {/* Table implementation */}
      </table>
    </div>
  );
}
```

## Resources

- [Civic Tech Best Practices](../ACCESSIBILITY_GUIDE.md)
- [Contributing Guidelines](../CONTRIBUTING.md)
- [Technical Design Document](../TECHNICAL_DESIGN.md)

---

**Remember**: Your code serves the community. Write it with care, test it thoroughly, and make it accessible to everyone.
