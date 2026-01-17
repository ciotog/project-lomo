# Accessibility Guide for CivicTechWR Projects

Accessibility is fundamental to civic technology. Our projects must work for everyone in our community, regardless of ability, technology, or circumstances.

## Why Accessibility Matters in Civic Tech

- **Equity**: Public-serving technology should be usable by all community members
- **Legal compliance**: Many jurisdictions require accessibility for public services
- **Better design**: Accessible design improves usability for everyone
- **Community values**: Inclusion and accessibility align with civic tech principles

## Accessibility Standards

### WCAG 2.1 Guidelines

We follow [Web Content Accessibility Guidelines (WCAG) 2.1](https://www.w3.org/WAI/WCAG21/quickref/) at Level AA:

#### 1. Perceivable

##### Users must be able to perceive the information being presented

- **Text alternatives**: Provide alt text for images
- **Captions**: Add captions for videos
- **Color contrast**: Ensure sufficient contrast ratios
- **Resizable text**: Allow text to be enlarged up to 200%

#### 2. Operable

##### Interface components must be operable

- **Keyboard accessible**: All functionality available via keyboard
- **No seizures**: Avoid content that causes seizures
- **Enough time**: Provide enough time to read content
- **Navigation**: Help users navigate and find content

#### 3. Understandable

##### Information and UI operation must be understandable

- **Readable**: Make text readable and understandable
- **Predictable**: Make content appear and operate predictably
- **Input assistance**: Help users avoid and correct mistakes

#### 4. Robust

##### Content must be robust enough for various assistive technologies

- **Compatible**: Maximize compatibility with assistive technologies
- **Valid code**: Use valid, semantic HTML

## Implementation Checklist

### Planning Phase

- [ ] Include accessibility in project requirements
- [ ] Consider diverse user needs in design phase
- [ ] Plan for accessibility testing throughout development
- [ ] Budget time for accessibility improvements

### Design Phase

- [ ] Use sufficient color contrast (4.5:1 for normal text, 3:1 for large text)
- [ ] Don't rely solely on color to convey information
- [ ] Design for 200% zoom without horizontal scrolling
- [ ] Plan logical focus order for interactive elements
- [ ] Ensure touch targets are at least 44x44 pixels

### Development Phase

- [ ] Use semantic HTML elements
- [ ] Provide proper heading structure (h1, h2, h3...)
- [ ] Add alt text for images
- [ ] Ensure keyboard navigation works
- [ ] Test with screen readers
- [ ] Validate HTML and check for accessibility errors

### Testing Phase

- [ ] Test with keyboard only
- [ ] Test with screen reader software
- [ ] Test at 200% zoom
- [ ] Test with high contrast mode
- [ ] Get feedback from users with disabilities

## Common Accessibility Requirements

### Images and Media

**Images:**

```html
<!-- Informative images -->
<img src="chart.png" alt="Budget increased 15% from 2023 to 2024">

<!-- Decorative images -->
<img src="decoration.png" alt="" role="presentation">

<!-- Complex images -->
<img src="complex-chart.png" alt="Detailed budget breakdown"
     longdesc="budget-details.html">
```

**Videos:**

- Provide captions for all speech
- Include audio descriptions for visual content
- Offer transcripts

### Forms

**Accessible form design:**

```html
<label for="email">Email Address (required)</label>
<input type="email" id="email" name="email" required
       aria-describedby="email-error">
<div id="email-error" role="alert" aria-live="polite">
  Please enter a valid email address
</div>
```

**Form requirements:**

- Associate labels with form controls
- Group related fields with fieldset/legend
- Provide clear error messages
- Indicate required fields
- Use appropriate input types

### Navigation

**Accessible navigation:**

```html
<nav aria-label="Main navigation">
  <ul>
    <li><a href="/" aria-current="page">Home</a></li>
    <li><a href="/about">About</a></li>
    <li><a href="/contact">Contact</a></li>
  </ul>
</nav>
```

**Navigation requirements:**

- Provide skip links to main content
- Use landmarks (header, nav, main, footer)
- Indicate current page in navigation
- Ensure logical tab order

### Content Structure

**Heading structure:**

```html
<h1>Main Page Title</h1>
  <h2>Section Heading</h2>
    <h3>Subsection Heading</h3>
    <h3>Another Subsection</h3>
  <h2>Another Section</h2>
```

**Requirements:**

- Use headings to structure content logically
- Don't skip heading levels
- Use lists for grouped content
- Provide table headers for data tables

### Interactive Elements

**Buttons and links:**

```html
<!-- Button for actions -->
<button type="submit">Submit Application</button>

<!-- Link for navigation -->
<a href="/services">View All Services</a>

<!-- Button that looks like link -->
<button type="button" class="link-style" onclick="toggleDetails()">
  Show Details
</button>
```

**Requirements:**

- Use buttons for actions, links for navigation
- Provide clear, descriptive text
- Ensure adequate size for touch (44x44px minimum)
- Show focus indicators

## Testing Tools and Methods

### Automated Testing Tools

**Browser Extensions:**

- [axe DevTools](https://www.deque.com/axe/devtools/) - Comprehensive accessibility testing
- [WAVE](https://wave.webaim.org/extension/) - Visual accessibility evaluation
- [Lighthouse](https://developers.google.com/web/tools/lighthouse) - Includes accessibility audit

**Command Line Tools:**

- [axe-core](https://github.com/dequelabs/axe-core) - Automated testing in CI/CD
- [Pa11y](https://pa11y.org/) - Command line accessibility testing

**Code Integration:**

```javascript
// Example: axe-core in automated tests
import { axe, toHaveNoViolations } from 'jest-axe';

test('should not have accessibility violations', async () => {
  const { container } = render(<YourComponent />);
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

### Manual Testing Methods

**Keyboard Testing:**

1. Unplug your mouse
2. Navigate using only:
   - Tab (forward)
   - Shift+Tab (backward)
   - Enter/Space (activate)
   - Arrow keys (within components)
3. Verify all functionality is accessible

**Screen Reader Testing:**

- **Windows**: NVDA (free) or JAWS
- **Mac**: VoiceOver (built-in)
- **Mobile**: VoiceOver (iOS) or TalkBack (Android)

**Visual Testing:**

- Test at 200% zoom
- Test with high contrast mode
- Test with different color combinations
- Remove CSS to check content order

### User Testing with Disabilities

**Finding participants:**

- Partner with local disability organizations
- Reach out through accessibility communities
- Offer compensation for testing time
- Ensure testing is accessible (location, timing, format)

**Testing guidelines:**

- Let users use their own assistive technology
- Don't assume what barriers they might face
- Ask about their typical workflows
- Focus on real tasks, not just navigation

## Common Civic Tech Scenarios

### Data Visualization

**Making charts accessible:**

```html
<div role="img" aria-labelledby="chart-title" aria-describedby="chart-desc">
  <h3 id="chart-title">City Budget 2024</h3>
  <p id="chart-desc">
    Pie chart showing budget allocation: Public Safety 40%,
    Infrastructure 25%, Education 20%, Parks 10%, Other 5%
  </p>
  <!-- Chart implementation -->
  <table class="sr-only">
    <!-- Data table alternative for screen readers -->
  </table>
</div>
```

### Maps and Location Data

**Accessible maps:**

- Provide text alternatives to map information
- Include address lists alongside map visualizations
- Ensure map controls are keyboard accessible
- Offer alternative ways to input location data

### Public Information Portals

**Document accessibility:**

- Provide HTML alternatives to PDF documents
- Use proper heading structure in documents
- Make forms fillable and accessible
- Provide summaries of complex documents

### Mobile Civic Apps

**Mobile accessibility:**

- Test with mobile screen readers
- Ensure touch targets are large enough
- Support device rotation
- Work with voice control features

## Accessibility in Different Technologies

### React/JavaScript Applications

```javascript
// Use semantic HTML
function NavigationMenu() {
  return (
    <nav aria-label="Main navigation">
      <ul role="menubar">
        {menuItems.map(item => (
          <li key={item.id} role="none">
            <a href={item.url} role="menuitem">
              {item.label}
            </a>
          </li>
        ))}
      </ul>
    </nav>
  );
}

// Manage focus properly
function Modal({ isOpen, onClose, children }) {
  const modalRef = useRef();

  useEffect(() => {
    if (isOpen) {
      modalRef.current?.focus();
    }
  }, [isOpen]);

  return isOpen ? (
    <div
      role="dialog"
      aria-modal="true"
      ref={modalRef}
      tabIndex="-1"
    >
      {children}
    </div>
  ) : null;
}
```

### Python/Django Applications

```python
# Use Django's built-in accessibility features
from django import forms

class ContactForm(forms.Form):
    name = forms.CharField(
        max_length=100,
        widget=forms.TextInput(attrs={
            'aria-describedby': 'name-help',
            'required': True
        })
    )

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Add aria-labels to form fields
        for field_name, field in self.fields.items():
            field.widget.attrs['aria-label'] = field.label
```

### Static Sites (Jekyll/Hugo)

```markdown
<!-- Accessible markdown patterns -->

# Main Heading

## Section Heading

[Descriptive link text](url) instead of "click here"

![Alt text describing the image content](image.jpg)

| Header 1 | Header 2 |
|----------|----------|
| Data 1   | Data 2   |
```

## Resources and References

### Guidelines and Standards

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Section 508](https://www.section508.gov/) (US Federal)
- [AODA](https://www.ontario.ca/page/accessibility-laws) (Ontario)

### Testing Tools

- [Axe Accessibility Checker](https://www.deque.com/axe/)
- [WAVE Web Accessibility Evaluator](https://wave.webaim.org/)
- [Colour Contrast Analyser](https://www.tpgi.com/color-contrast-checker/)

### Learning Resources

- [WebAIM](https://webaim.org/) - Web accessibility tutorials
- [A11y Project](https://www.a11yproject.com/) - Community-driven accessibility resources
- [Inclusive Design Principles](https://inclusivedesignprinciples.org/)

### Local Resources

- [CNIB](https://cnib.ca/) - Support for blind and partially sighted
- [March of Dimes Canada](https://www.marchofdimes.ca/) - Disability services
- [Accessibility Directorate of Ontario](https://www.ontario.ca/page/accessibility-directorate-ontario)

## Getting Help

### CTWR Community Support

- Ask in community channels for accessibility guidance
- Request accessibility reviews from experienced community members
- Share accessibility challenges and solutions with other projects

### Professional Resources

- Consider hiring accessibility consultants for complex projects
- Partner with disability advocacy organizations
- Engage users with disabilities throughout the development process

---

**Remember**: Accessibility is not a checkbox to tick—it's an ongoing commitment to inclusive design that serves our entire community. Start with accessibility in mind, test regularly, and listen to user feedback.
