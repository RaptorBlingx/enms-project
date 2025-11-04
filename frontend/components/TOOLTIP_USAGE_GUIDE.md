# Tooltip Component - Usage Guide

## Quick Start

### 1. Include Required Files

Add these lines to your HTML `<head>`:

```html
<!-- Tooltip Component CSS -->
<link rel="stylesheet" href="/components/tooltip.css">

<!-- Font Awesome (if not already included) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
```

Add this before closing `</body>`:

```html
<!-- Tooltip Component JavaScript -->
<script src="/components/tooltip.js"></script>
```

### 2. Basic HTML Usage

```html
<button>
  Click Me
  <span class="tooltip-wrapper">
    <i class="fa-solid fa-circle-info tooltip-icon"></i>
    <span class="tooltip-content">This button performs an important action.</span>
  </span>
</button>
```

---

## HTML Examples

### Standard Tooltip (Top Position)
```html
<span class="tooltip-wrapper">
  <i class="fa-solid fa-circle-info tooltip-icon"></i>
  <span class="tooltip-content">Default tooltip appears above the icon.</span>
</span>
```

### Bottom Position
```html
<span class="tooltip-wrapper tooltip-bottom">
  <i class="fa-solid fa-circle-question tooltip-icon"></i>
  <span class="tooltip-content">This tooltip appears below the icon.</span>
</span>
```

### Left Position
```html
<span class="tooltip-wrapper tooltip-left">
  <i class="fa-solid fa-circle-info tooltip-icon"></i>
  <span class="tooltip-content">Tooltip on the left side.</span>
</span>
```

### Right Position
```html
<span class="tooltip-wrapper tooltip-right">
  <i class="fa-solid fa-circle-info tooltip-icon"></i>
  <span class="tooltip-content">Tooltip on the right side.</span>
</span>
```

### Small Size
```html
<span class="tooltip-wrapper">
  <i class="fa-solid fa-circle-info tooltip-icon"></i>
  <span class="tooltip-content tooltip-small">Compact tip</span>
</span>
```

### Large Size
```html
<span class="tooltip-wrapper">
  <i class="fa-solid fa-circle-info tooltip-icon"></i>
  <span class="tooltip-content tooltip-large">This is a larger tooltip with more detailed information for complex features.</span>
</span>
```

### Themed Tooltips

**Success:**
```html
<span class="tooltip-wrapper tooltip-success">
  <i class="fa-solid fa-circle-check tooltip-icon"></i>
  <span class="tooltip-content">Operation completed successfully!</span>
</span>
```

**Warning:**
```html
<span class="tooltip-wrapper tooltip-warning">
  <i class="fa-solid fa-triangle-exclamation tooltip-icon"></i>
  <span class="tooltip-content">This action cannot be undone.</span>
</span>
```

**Error:**
```html
<span class="tooltip-wrapper tooltip-error">
  <i class="fa-solid fa-circle-xmark tooltip-icon"></i>
  <span class="tooltip-content">An error occurred. Please try again.</span>
</span>
```

**Light Theme:**
```html
<span class="tooltip-wrapper tooltip-light">
  <i class="fa-solid fa-circle-info tooltip-icon"></i>
  <span class="tooltip-content">Light themed tooltip for dark backgrounds.</span>
</span>
```

### Inline Tooltip (within text)
```html
<p>
  This feature uses AI 
  <span class="tooltip-wrapper tooltip-inline">
    <i class="fa-solid fa-circle-info tooltip-icon"></i>
    <span class="tooltip-content tooltip-small">Artificial Intelligence: Computer systems that mimic human cognition.</span>
  </span>
  to analyze patterns.
</p>
```

---

## JavaScript Usage

### Creating Tooltips Programmatically

```javascript
// Create a tooltip
const tooltip = createTooltip({
  text: 'This is helpful information',
  position: 'top',        // top, bottom, left, right
  theme: 'info',          // info, success, warning, error, light
  size: 'normal',         // small, normal, large
  icon: 'fa-circle-info'  // Font Awesome icon class
});

// Add to DOM
document.querySelector('.my-element').appendChild(tooltip);
```

### Dynamic Content with Tooltips

If you add tooltips after page load:

```javascript
// After adding new HTML with tooltips
window.tooltipManager.refresh();

// Or add a single tooltip
const newTooltip = document.querySelector('.new-tooltip-wrapper');
window.tooltipManager.addTooltip(newTooltip);
```

### Programmatic Control

```javascript
// Close all open tooltips
window.tooltipManager.closeAllTooltips();

// Remove a specific tooltip
window.tooltipManager.removeTooltip(tooltipElement);
```

---

## Real-World Examples

### Dashboard Button with Tooltip
```html
<button id="industrialHybridBtn" class="nav-button" data-target="industrial-hybrid">
  <i class="fa-solid fa-industry"></i>
  <span class="button-title">Industrial Hybrid</span>
  <span class="tooltip-wrapper">
    <i class="fa-solid fa-circle-info tooltip-icon"></i>
    <span class="tooltip-content">View real-time data from edge computing devices and industrial sensors. Combines on-premise and cloud processing.</span>
  </span>
</button>
```

### Form Field with Help Text
```html
<div class="form-group">
  <label for="energyThreshold">
    Energy Threshold (kWh)
    <span class="tooltip-wrapper tooltip-inline">
      <i class="fa-solid fa-circle-question tooltip-icon"></i>
      <span class="tooltip-content tooltip-small">Alert will trigger when consumption exceeds this value. Typical range: 100-500 kWh.</span>
    </span>
  </label>
  <input type="number" id="energyThreshold" name="energyThreshold">
</div>
```

### Status Indicator with Explanation
```html
<div class="device-status">
  <span class="status-badge status-online">Online</span>
  <span class="tooltip-wrapper tooltip-inline">
    <i class="fa-solid fa-circle-info tooltip-icon"></i>
    <span class="tooltip-content">Device is connected and actively sending data. Last update: 2 seconds ago.</span>
  </span>
</div>
```

### Complex Feature with Warning
```html
<button class="btn-danger" onclick="resetDevice()">
  Reset Device
  <span class="tooltip-wrapper tooltip-warning tooltip-bottom">
    <i class="fa-solid fa-triangle-exclamation tooltip-icon"></i>
    <span class="tooltip-content">Resetting will clear all cached data and restart the device. This process takes approximately 30 seconds and cannot be interrupted.</span>
  </span>
</button>
```

### Table Header with Explanation
```html
<th>
  Energy Efficiency
  <span class="tooltip-wrapper tooltip-inline">
    <i class="fa-solid fa-circle-info tooltip-icon"></i>
    <span class="tooltip-content tooltip-small">Ratio of useful output to total energy consumed. Higher values indicate better performance. Industry standard: 65-85%.</span>
  </span>
</th>
```

---

## Best Practices

### Content Guidelines

1. **Be Concise:** Keep tooltips to 1-2 sentences (max 50 words)
2. **Be Helpful:** Answer "What is this?" and "Why does it matter?"
3. **Avoid Jargon:** Explain technical terms or acronyms
4. **Be Consistent:** Use same terminology across all tooltips

### When to Use Tooltips

✅ **USE for:**
- Explaining unfamiliar features
- Providing context for metrics/data
- Warning about destructive actions
- Clarifying technical terminology
- Showing keyboard shortcuts
- Explaining status indicators

❌ **DON'T USE for:**
- Essential information (use visible text instead)
- Very long explanations (link to docs instead)
- Repeating visible labels
- Mobile-only interfaces (use other patterns)

### Positioning Guidelines

- **Top:** Default for most cases
- **Bottom:** Use in headers/navigation to avoid covering content
- **Left/Right:** Use for inline help within dense layouts
- **Auto:** Let JavaScript adjust based on viewport

### Accessibility

- Tooltips automatically support keyboard navigation (Tab, Enter, Escape)
- Screen readers can access tooltip content via aria-label
- High contrast mode automatically adjusts colors
- Touch devices show tooltips on tap (not hover)

---

## Customization

### CSS Variables

Override default colors in your stylesheet:

```css
:root {
  --tooltip-bg: #1f2937;
  --tooltip-text: #f3f4f6;
  --tooltip-icon-color: #3b82f6;
}
```

### Custom Icon

Use any Font Awesome icon:

```html
<i class="fa-solid fa-lightbulb tooltip-icon"></i>  <!-- Idea -->
<i class="fa-solid fa-graduation-cap tooltip-icon"></i>  <!-- Learning -->
<i class="fa-solid fa-shield-halved tooltip-icon"></i>  <!-- Security -->
```

### Animation Timing

Adjust hover delay in CSS:

```css
.tooltip-wrapper:hover .tooltip-content {
  animation-delay: 0.5s; /* Show after 500ms hover */
}
```

---

## Troubleshooting

### Tooltip Not Showing

1. Check CSS/JS files are included
2. Verify Font Awesome is loaded
3. Ensure `.tooltip-wrapper` has both `.tooltip-icon` and `.tooltip-content`
4. Check browser console for errors

### Tooltip Cut Off at Screen Edge

The JavaScript automatically adjusts position, but ensure:
1. Parent elements don't have `overflow: hidden`
2. Tooltip has high enough z-index (default 9999)
3. Call `window.tooltipManager.refresh()` after DOM changes

### Tooltip Not Working on Touch Devices

- Touch devices require tap/click (not hover)
- JavaScript automatically handles touch events
- Ensure tooltip.js is loaded

---

## Browser Support

- Chrome/Edge: ✅ Full support
- Firefox: ✅ Full support
- Safari: ✅ Full support
- Mobile browsers: ✅ Touch-optimized
- IE11: ⚠️ Partial support (no CSS variables)

---

## Performance

- Minimal impact: ~5KB CSS + 8KB JS (uncompressed)
- No external dependencies (except Font Awesome)
- Lazy evaluation: Only processes on hover/click
- GPU-accelerated animations

---

## License

Part of ENMS Demo project - use freely within the project.
