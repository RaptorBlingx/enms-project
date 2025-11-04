# ENMS Demo - Tooltip & Documentation Implementation Plan

**Project Goal:** Make the ENMS Demo self-explanatory for reviewers unfamiliar with the project by adding contextual tooltips throughout the interface and improving Grafana panel descriptions.

**Target Audience:** Reviewers who need to understand the project without prior knowledge

**Implementation Date:** November 3, 2025

---

## 📋 TODO List

### Phase 1: Tooltip Infrastructure (Priority: CRITICAL)
- [ ] **Task 1:** Create reusable tooltip CSS/JS component
  - Icon options: ℹ️ (info) or ❓ (help)
  - Hover behavior with smooth transitions
  - Smart positioning (avoid viewport overflow)
  - Arrow indicators pointing to element
  - Responsive behavior for mobile
  - Light/dark theme support
  - **Files:** Create `frontend/components/tooltip.css` and `frontend/components/tooltip.js`

### Phase 2: Frontend HTML Pages (Priority: HIGH)

- [ ] **Task 2:** index.html - Main Dashboard
  - Profile selector buttons (Operator, Technician, Manager) - explain role differences
  - Navbar dashboard buttons (8 buttons total):
    - Industrial Hybrid Edge
    - Sensor Explorer
    - Device Management
    - Interactive Analysis
    - Digital Product Passport
    - Node-RED
    - Fleet Operations
    - Performance Comparison
  - Sidebar info links (About, ISO 50001, etc.)
  - User menu options (Change Profile, Logout)

- [ ] **Task 3:** device_management.html
  - Device status indicators (online/offline/error)
  - Action buttons (configure, restart, delete)
  - Filter options
  - Device types and categories
  - Connection states
  - Configuration fields and parameters

- [ ] **Task 4:** dpp_page.html (Digital Product Passport)
  - Manufacturing data fields
  - Sustainability metrics
  - Lifecycle tracking phases
  - Compliance indicators
  - Environmental impact data
  - Circularity information

- [ ] **Task 5:** analysis/analysis_page.html
  - Chart type selectors
  - Data filter options
  - Time range pickers
  - Export format options
  - Analysis parameters
  - Statistical metrics

- [ ] **Task 6:** Content Pages Enhancement
  - about.html - technical terms
  - iso50001.html - ISO standard concepts
  - artistic-elements.html - design philosophy
  - workshop.html - training benefits
  - contact.html - support channels

### Phase 3: Grafana Dashboards (Priority: HIGH)

- [ ] **Task 7:** Audit All Dashboards
  - Industrial-Hybrid-Edge-System.json
  - Sensor-Data-Explorer.json
  - Machine-Performance-Comparison.json
  - fleet-operations.json
  - esp32.json
  - Create mapping: Dashboard → Panels → Description Status

- [ ] **Task 8:** Fleet Operations Dashboard
  - Review panel names for clarity
  - Add description to each panel explaining:
    - What data is shown
    - Why it matters
    - How to interpret it
    - Any thresholds or alerts

- [ ] **Task 9:** Performance Comparison Dashboard
  - Document comparison metrics
  - Explain baseline references
  - Add interpretation guidelines
  - Clarify performance indicators

- [ ] **Task 10:** Industrial Hybrid Edge Dashboard
  - Explain hybrid architecture
  - Document edge computing metrics
  - Clarify system health indicators
  - Add troubleshooting hints

- [ ] **Task 11:** Sensor Data Explorer Dashboard
  - Explain sensor types
  - Document data collection intervals
  - Clarify data quality indicators
  - Add calibration information

- [ ] **Task 12:** ESP32 & Other Dashboards
  - Ensure consistent naming
  - Add comprehensive descriptions
  - Document data sources
  - Explain visualization choices

### Phase 4: Documentation & User Guidance (Priority: MEDIUM)

- [ ] **Task 13:** Create Welcome Modal
  - Brief system overview
  - Navigation guide
  - Profile differences explanation
  - Key features tour
  - Tooltip system explanation

- [ ] **Task 14:** Quick Reference Guide
  - Create `/frontend/user-guide.html`
  - Keyboard shortcuts
  - Common workflows
  - Troubleshooting tips
  - FAQ section

### Phase 5: Testing & Quality Assurance (Priority: HIGH)

- [ ] **Task 15:** Comprehensive Testing
  - Test tooltips on all pages
  - Verify positioning on different screen sizes
  - Check mobile responsiveness
  - Validate content accuracy
  - Ensure consistent styling
  - Cross-browser compatibility
  - Performance impact assessment

- [ ] **Task 16:** User Feedback & Iteration
  - Internal team review
  - Test with someone unfamiliar with project
  - Gather feedback on clarity
  - Refine tooltip content
  - Adjust positioning if needed

---

## 🎯 Success Criteria

1. **Coverage:** Every interactive element has a tooltip or label
2. **Clarity:** Reviewers can understand each feature without asking questions
3. **Consistency:** All tooltips follow same design pattern and tone
4. **Grafana:** Every panel has a clear title and description
5. **Accessibility:** Tooltips work with keyboard navigation
6. **Performance:** No noticeable lag when hovering

---

## 📝 Tooltip Content Guidelines

### Writing Style
- **Concise:** 1-2 sentences maximum
- **Clear:** Avoid jargon, explain acronyms
- **Helpful:** Answer "What is this?" and "Why should I care?"
- **Consistent:** Use same terminology throughout

### Template Examples

**For Features:**
```
"[Feature Name]: [What it does]. [Why it's useful/when to use it]."
Example: "Sensor Explorer: Visualize real-time sensor data from all connected devices. Use this to identify trends and anomalies."
```

**For Metrics:**
```
"[Metric Name]: [What it measures]. [Normal range or interpretation guide]."
Example: "Energy Efficiency: Ratio of useful output to total energy consumed. Higher values indicate better performance."
```

**For Actions:**
```
"[Action]: [What happens when clicked]. [Any prerequisites or warnings]."
Example: "Restart Device: Safely reboot the selected device. Device will be offline for ~30 seconds."
```

---

## 🔧 Technical Implementation Notes

### Tooltip Component Structure
```html
<span class="tooltip-wrapper">
  <i class="fa-solid fa-circle-info tooltip-icon"></i>
  <span class="tooltip-content">Your helpful text here</span>
</span>
```

### CSS Requirements
- z-index management
- Smooth fade-in/out transitions
- Arrow positioning calculations
- Max-width constraints
- Mobile touch behavior

### JavaScript Requirements
- Position calculation (prevent overflow)
- Delay before showing (300ms hover)
- Touch device support
- Keyboard accessibility (focus states)

---

## 📊 Grafana Panel Description Format

Each panel should have:
1. **Title:** Clear, descriptive name (3-5 words)
2. **Description:** Comprehensive explanation including:
   - Purpose of the panel
   - Data source and collection method
   - How to interpret the visualization
   - Normal operating ranges
   - What to do if values are abnormal
   - Related panels or dashboards

Example:
```json
{
  "title": "Real-Time Power Consumption",
  "description": "Displays instantaneous power usage across all monitored devices in watts. Data is collected every 5 seconds from energy meters. Normal range: 500-2000W. Spikes above 2500W may indicate equipment issues. Compare with 'Historical Power Trends' panel for context."
}
```

---

## 🚀 Implementation Order (Recommended)

1. **Start:** Create tooltip component (Task 1)
2. **Quick Win:** Add tooltips to index.html dashboard buttons (Task 2)
3. **High Impact:** Grafana dashboard audit and fleet-operations (Tasks 7-8)
4. **Breadth:** Remaining HTML pages (Tasks 3-6)
5. **Depth:** Complete all Grafana dashboards (Tasks 9-12)
6. **Polish:** Documentation and welcome modal (Tasks 13-14)
7. **Finish:** Testing and iteration (Tasks 15-16)

---

## 📈 Progress Tracking

- **Phase 1:** 0/1 tasks complete (0%)
- **Phase 2:** 0/5 tasks complete (0%)
- **Phase 3:** 0/6 tasks complete (0%)
- **Phase 4:** 0/2 tasks complete (0%)
- **Phase 5:** 0/2 tasks complete (0%)

**Overall Progress:** 0/16 tasks complete (0%)

---

## 💡 Additional Considerations

- **Internationalization:** Keep English concise for potential future translation
- **Accessibility:** Ensure WCAG 2.1 AA compliance
- **Mobile:** Test on actual devices, not just browser resize
- **Load Time:** Lazy-load tooltip content if needed
- **Analytics:** Consider tracking which tooltips are most used
- **Version Control:** Keep backup of Grafana dashboards before editing

---

**Last Updated:** November 3, 2025
**Status:** Planning Complete - Ready for Implementation
