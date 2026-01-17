# Testing Directory

This directory contains all tests for your CivicTechWR project. Comprehensive testing ensures your civic technology solutions work reliably for the community.

## Testing Philosophy

For civic technology projects, testing goes beyond just verifying code works:

- **Reliability**: Community members depend on these tools
- **Accessibility**: Ensure solutions work for everyone
- **Security**: Protect user data and system integrity
- **Performance**: Verify tools work under real-world conditions

## Test Structure

```text
tests/
├── unit/               # Unit tests for individual functions/components
├── integration/        # Integration tests for feature workflows
├── accessibility/      # Accessibility compliance tests
├── performance/        # Load and performance tests
├── security/          # Security vulnerability tests
├── user/              # User acceptance tests
├── fixtures/          # Test data and mock files
└── helpers/           # Testing utilities and helpers
```

## Types of Tests

### 1. Unit Tests

Test individual functions, components, or modules in isolation.

```javascript
// Example: Testing a utility function
import { formatCurrency } from '../src/utils/formatting';

describe('formatCurrency', () => {
  test('formats currency correctly', () => {
    expect(formatCurrency(1234.56)).toBe('$1,234.56');
  });

  test('handles zero values', () => {
    expect(formatCurrency(0)).toBe('$0.00');
  });

  test('handles negative values', () => {
    expect(formatCurrency(-100)).toBe('-$100.00');
  });
});
```

### 2. Integration Tests

Test how different parts of your application work together.

```javascript
// Example: Testing API integration
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import CityServiceSearch from '../src/components/CityServiceSearch';

describe('CityServiceSearch Integration', () => {
  test('searches and displays city services', async () => {
    render(<CityServiceSearch />);

    const searchInput = screen.getByLabelText('Search city services');
    const searchButton = screen.getByRole('button', { name: 'Search' });

    await userEvent.type(searchInput, 'parking permits');
    await userEvent.click(searchButton);

    await waitFor(() => {
      expect(screen.getByText('Parking Permit Application')).toBeInTheDocument();
    });
  });
});
```

### 3. Accessibility Tests

Ensure your application works with assistive technologies.

```javascript
// Example: Accessibility testing
import { axe, toHaveNoViolations } from 'jest-axe';
import { render } from '@testing-library/react';
import ContactForm from '../src/components/ContactForm';

expect.extend(toHaveNoViolations);

describe('ContactForm Accessibility', () => {
  test('should not have accessibility violations', async () => {
    const { container } = render(<ContactForm />);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });

  test('keyboard navigation works correctly', async () => {
    render(<ContactForm />);
    // Test keyboard navigation through form elements
    // Verify focus management and tab order
  });
});
```

### 4. Performance Tests

Verify your application performs well under realistic conditions.

```javascript
// Example: Performance testing
import { performance } from 'perf_hooks';

describe('Data Processing Performance', () => {
  test('processes large datasets efficiently', () => {
    const largeDataset = generateTestData(10000);
    const startTime = performance.now();

    const result = processPublicData(largeDataset);

    const endTime = performance.now();
    const executionTime = endTime - startTime;

    expect(executionTime).toBeLessThan(1000); // Should complete in under 1 second
    expect(result).toHaveLength(10000);
  });
});
```

### 5. Security Tests

Test for common security vulnerabilities.

```javascript
// Example: Security testing
describe('Input Validation Security', () => {
  test('prevents SQL injection in search queries', () => {
    const maliciousInput = "'; DROP TABLE users; --";
    expect(() => validateSearchQuery(maliciousInput)).toThrow();
  });

  test('sanitizes HTML input', () => {
    const htmlInput = '<script>alert("xss")</script>';
    const sanitized = sanitizeInput(htmlInput);
    expect(sanitized).not.toContain('<script>');
  });

  test('validates API authentication', async () => {
    const response = await fetch('/api/protected', {
      headers: { 'Authorization': 'invalid-token' }
    });
    expect(response.status).toBe(401);
  });
});
```

### 6. User Acceptance Tests

Test complete user workflows to ensure the application meets user needs.

```javascript
// Example: User workflow test
describe('Citizen Service Request Workflow', () => {
  test('citizen can submit and track service request', async () => {
    // 1. Navigate to service request page
    await page.goto('/service-request');

    // 2. Fill out service request form
    await page.fill('[data-testid="issue-description"]', 'Pothole on Main St');
    await page.fill('[data-testid="location"]', '123 Main Street');
    await page.selectOption('[data-testid="category"]', 'road-maintenance');

    // 3. Submit request
    await page.click('[data-testid="submit-request"]');

    // 4. Verify confirmation and tracking number
    await expect(page.locator('[data-testid="confirmation"]')).toBeVisible();
    const trackingNumber = await page.textContent('[data-testid="tracking-number"]');
    expect(trackingNumber).toMatch(/REQ-\d{6}/);

    // 5. Verify can track request status
    await page.goto(`/track/${trackingNumber}`);
    await expect(page.locator('[data-testid="request-status"]')).toContainText('Submitted');
  });
});
```

## Testing Setup by Technology

### JavaScript/React Testing

```json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:a11y": "jest --testNamePattern='accessibility'",
    "test:e2e": "playwright test"
  },
  "devDependencies": {
    "@testing-library/react": "^13.0.0",
    "@testing-library/jest-dom": "^5.16.0",
    "@testing-library/user-event": "^14.0.0",
    "jest-axe": "^7.0.0",
    "@playwright/test": "^1.28.0"
  }
}
```

### Python/Django Testing

```python
# settings/test.py
from .base import *

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': ':memory:',
    }
}

# Disable migrations for faster tests
class DisableMigrations:
    def __contains__(self, item):
        return True
    def __getitem__(self, item):
        return None

MIGRATION_MODULES = DisableMigrations()
```

### Flutter Testing

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.3.2
  build_runner: ^2.3.0
```

## Test Data and Fixtures

### Creating Realistic Test Data

```javascript
// fixtures/sampleData.js
export const sampleCityServices = [
  {
    id: 1,
    name: 'Parking Permit Application',
    category: 'transportation',
    description: 'Apply for residential parking permits',
    estimatedTime: '2-3 business days',
    cost: 50.00,
    requirements: ['Proof of residence', 'Vehicle registration']
  },
  {
    id: 2,
    name: 'Building Permit',
    category: 'construction',
    description: 'Submit building permit applications',
    estimatedTime: '4-6 weeks',
    cost: 150.00,
    requirements: ['Architectural plans', 'Site survey']
  }
];
```

### Mock External APIs

```javascript
// helpers/mockApi.js
import { rest } from 'msw';
import { setupServer } from 'msw/node';

export const server = setupServer(
  rest.get('/api/city-services', (req, res, ctx) => {
    return res(ctx.json(sampleCityServices));
  }),

  rest.post('/api/service-requests', (req, res, ctx) => {
    return res(ctx.json({
      id: 'REQ-123456',
      status: 'submitted',
      estimatedCompletion: '2024-02-15'
    }));
  })
);
```

## Continuous Integration Testing

### GitHub Actions Configuration

```yaml
# .github/workflows/test.yml
name: Test Suite

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run unit tests
        run: npm run test:coverage

      - name: Run accessibility tests
        run: npm run test:a11y

      - name: Run end-to-end tests
        run: npm run test:e2e

      - name: Upload coverage reports
        uses: codecov/codecov-action@v3
```

## Testing Best Practices

### 1. Test Naming

```javascript
// Good: Descriptive test names
describe('UserRegistration', () => {
  test('should create new user account when valid data is provided', () => {
    // Test implementation
  });

  test('should reject registration when email is already in use', () => {
    // Test implementation
  });

  test('should require strong password with minimum 8 characters', () => {
    // Test implementation
  });
});
```

### 2. Test Organization

- Group related tests with `describe` blocks
- Use `beforeEach` and `afterEach` for common setup/cleanup
- Keep tests independent and isolated
- Test one thing at a time

### 3. Civic Tech Specific Testing

```javascript
// Test for real-world civic tech scenarios
describe('Emergency Service Directory', () => {
  test('displays emergency services when user location is available', async () => {
    // Mock geolocation
    mockGeolocation({ latitude: 43.4643, longitude: -80.5204 });

    render(<EmergencyServices />);

    await waitFor(() => {
      expect(screen.getByText('Waterloo Regional Police')).toBeInTheDocument();
      expect(screen.getByText('Grand River Hospital')).toBeInTheDocument();
    });
  });

  test('provides alternative when location is unavailable', () => {
    // Mock location permission denied
    mockGeolocation(null, 'Permission denied');

    render(<EmergencyServices />);

    expect(screen.getByText('Enter your address manually')).toBeInTheDocument();
  });
});
```

## Coverage Goals

Aim for:

- **Unit tests**: 80%+ code coverage
- **Integration tests**: All critical user workflows
- **Accessibility tests**: All interactive components
- **Performance tests**: Key data processing functions
- **Security tests**: All user input validation

## Running Tests

### Local Development

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run specific test file
npm test UserProfile.test.js

# Run tests with coverage
npm run test:coverage

# Run only accessibility tests
npm run test:a11y
```

### Pre-commit Testing

```bash
# Run in pre-commit hook
npm run test:quick  # Fast subset of tests
npm run lint        # Code quality checks
npm run test:a11y   # Accessibility validation
```

## Debugging Tests

### Common Issues

1. **Async operations**: Use `waitFor` and proper async/await
2. **DOM cleanup**: Ensure components unmount between tests
3. **Mock cleanup**: Reset mocks in `afterEach`
4. **Test isolation**: Don't rely on test execution order

### Debugging Tools

```javascript
// Debug specific test
test('debug failing test', () => {
  const { debug } = render(<Component />);
  debug(); // Prints DOM to console
  // Test code
});

// Use screen.logTestingPlaygroundURL() for complex queries
screen.logTestingPlaygroundURL();
```

## Resources

### Testing Libraries

- [Jest](https://jestjs.io/) - JavaScript testing framework
- [React Testing Library](https://testing-library.com/react) - React component testing
- [Playwright](https://playwright.dev/) - End-to-end testing
- [jest-axe](https://github.com/nickcolley/jest-axe) - Accessibility testing

### Documentation

- [Testing Best Practices](https://kentcdodds.com/blog/common-mistakes-with-react-testing-library)
- [Accessibility Testing Guide](../ACCESSIBILITY_GUIDE.md)
- [Security Testing Checklist](https://owasp.org/www-project-web-security-testing-guide/)

---

**Remember**: Good tests give you confidence that your civic technology solution will work reliably when community members need it most.
