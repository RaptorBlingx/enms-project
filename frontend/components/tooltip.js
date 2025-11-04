/* ====================================================================
   ENMS Demo - Tooltip Component JavaScript
   Handles dynamic positioning, touch devices, and accessibility
   ==================================================================== */

(function() {
    'use strict';

    // Tooltip Manager Class
    class TooltipManager {
        constructor() {
            this.tooltips = [];
            this.activeTooltip = null;
            this.touchDevice = this.isTouchDevice();
            this.init();
        }

        // Check if device supports touch
        isTouchDevice() {
            return ('ontouchstart' in window) || 
                   (navigator.maxTouchPoints > 0) || 
                   (navigator.msMaxTouchPoints > 0);
        }

        // Initialize tooltip system
        init() {
            // Wait for DOM to be ready
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', () => this.setup());
            } else {
                this.setup();
            }
        }

        // Setup all tooltips
        setup() {
            // Find all tooltip wrappers
            const tooltipWrappers = document.querySelectorAll('.tooltip-wrapper');
            
            tooltipWrappers.forEach(wrapper => {
                const icon = wrapper.querySelector('.tooltip-icon');
                const content = wrapper.querySelector('.tooltip-content');
                
                if (icon && content) {
                    this.tooltips.push({ wrapper, icon, content });
                    
                    // Setup event listeners
                    if (this.touchDevice) {
                        this.setupTouchEvents(wrapper, icon, content);
                    } else {
                        this.setupHoverEvents(wrapper, icon, content);
                    }
                    
                    // Keyboard accessibility
                    this.setupKeyboardEvents(icon, wrapper);
                    
                    // Auto-position on hover to prevent viewport overflow
                    icon.addEventListener('mouseenter', () => {
                        setTimeout(() => this.adjustPosition(wrapper, content), 10);
                    });
                    
                    // Also adjust on mousemove for dynamic buttons
                    wrapper.addEventListener('mouseenter', () => {
                        setTimeout(() => this.adjustPosition(wrapper, content), 10);
                    });
                }
            });

            // Close tooltip when clicking outside
            if (this.touchDevice) {
                document.addEventListener('click', (e) => {
                    if (this.activeTooltip && !this.activeTooltip.contains(e.target)) {
                        this.closeAllTooltips();
                    }
                });
            }

            console.log(`[Tooltip] Initialized ${this.tooltips.length} tooltips`);
        }

        // Setup hover events for mouse devices
        setupHoverEvents(wrapper, icon, content) {
            let hoverTimeout;

            icon.addEventListener('mouseenter', () => {
                // Delay showing tooltip by 300ms
                hoverTimeout = setTimeout(() => {
                    this.adjustPosition(wrapper, content);
                }, 300);
            });

            icon.addEventListener('mouseleave', () => {
                clearTimeout(hoverTimeout);
            });
        }

        // Setup touch events for touch devices
        setupTouchEvents(wrapper, icon, content) {
            icon.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                
                // Close other tooltips first
                if (this.activeTooltip && this.activeTooltip !== wrapper) {
                    this.closeAllTooltips();
                }
                
                // Toggle this tooltip
                const isActive = wrapper.classList.contains('active');
                if (isActive) {
                    wrapper.classList.remove('active');
                    this.activeTooltip = null;
                } else {
                    wrapper.classList.add('active');
                    this.activeTooltip = wrapper;
                    this.adjustPosition(wrapper, content);
                }
            });
        }

        // Setup keyboard events for accessibility
        setupKeyboardEvents(icon, wrapper) {
            // Make icon focusable
            if (!icon.hasAttribute('tabindex')) {
                icon.setAttribute('tabindex', '0');
            }
            
            // Show on focus
            icon.addEventListener('focus', () => {
                wrapper.classList.add('active');
                this.activeTooltip = wrapper;
            });
            
            // Hide on blur
            icon.addEventListener('blur', () => {
                setTimeout(() => {
                    wrapper.classList.remove('active');
                    if (this.activeTooltip === wrapper) {
                        this.activeTooltip = null;
                    }
                }, 200);
            });
            
            // Handle Enter/Space key
            icon.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    const isActive = wrapper.classList.contains('active');
                    if (isActive) {
                        wrapper.classList.remove('active');
                        this.activeTooltip = null;
                    } else {
                        this.closeAllTooltips();
                        wrapper.classList.add('active');
                        this.activeTooltip = wrapper;
                    }
                }
                
                // Close on Escape
                if (e.key === 'Escape') {
                    wrapper.classList.remove('active');
                    if (this.activeTooltip === wrapper) {
                        this.activeTooltip = null;
                    }
                }
            });
        }

        // Adjust tooltip position to prevent viewport overflow
        adjustPosition(wrapper, content) {
            // Reset styles
            content.classList.remove('tooltip-edge-left', 'tooltip-edge-right');
            content.style.transform = '';
            
            // Get icon position
            const icon = wrapper.querySelector('.tooltip-icon');
            if (!icon) return;
            
            const iconRect = icon.getBoundingClientRect();
            const viewportWidth = window.innerWidth;
            const viewportHeight = window.innerHeight;
            
            // Get tooltip dimensions (make it visible temporarily to measure)
            const prevOpacity = content.style.opacity;
            const prevVisibility = content.style.visibility;
            content.style.opacity = '0';
            content.style.visibility = 'visible';
            const contentWidth = content.offsetWidth;
            const contentHeight = content.offsetHeight;
            content.style.opacity = prevOpacity;
            content.style.visibility = prevVisibility;
            
            // Determine vertical position
            const isBottom = wrapper.classList.contains('tooltip-bottom');
            const spaceAbove = iconRect.top;
            const spaceBelow = viewportHeight - iconRect.bottom;
            
            let finalTop;
            if (isBottom || spaceAbove < contentHeight + 20) {
                // Position below icon
                finalTop = iconRect.bottom + 12;
            } else {
                // Position above icon
                finalTop = iconRect.top - contentHeight - 12;
            }
            
            // Determine horizontal position (center on icon)
            const iconCenterX = iconRect.left + (iconRect.width / 2);
            let finalLeft = iconCenterX - (contentWidth / 2);
            
            // Adjust for viewport edges
            const margin = 10;
            if (finalLeft < margin) {
                finalLeft = margin;
            } else if (finalLeft + contentWidth > viewportWidth - margin) {
                finalLeft = viewportWidth - contentWidth - margin;
            }
            
            // Apply final position
            content.style.top = `${finalTop}px`;
            content.style.left = `${finalLeft}px`;
            content.style.bottom = 'auto';
            content.style.right = 'auto';
            
            // Adjust arrow position if tooltip was shifted horizontally
            const arrowOffset = iconCenterX - finalLeft;
            if (content.querySelector) {
                // Store arrow offset as CSS custom property for arrow positioning
                content.style.setProperty('--arrow-offset', `${arrowOffset}px`);
            }
        }

        // Close all active tooltips
        closeAllTooltips() {
            this.tooltips.forEach(({ wrapper }) => {
                wrapper.classList.remove('active');
            });
            this.activeTooltip = null;
        }

        // Add new tooltip dynamically (for SPAs or dynamic content)
        addTooltip(wrapperElement) {
            const icon = wrapperElement.querySelector('.tooltip-icon');
            const content = wrapperElement.querySelector('.tooltip-content');
            
            if (icon && content) {
                this.tooltips.push({ wrapper: wrapperElement, icon, content });
                
                if (this.touchDevice) {
                    this.setupTouchEvents(wrapperElement, icon, content);
                } else {
                    this.setupHoverEvents(wrapperElement, icon, content);
                }
                
                this.setupKeyboardEvents(icon, wrapperElement);
                
                console.log('[Tooltip] Added new tooltip dynamically');
            }
        }

        // Remove tooltip
        removeTooltip(wrapperElement) {
            const index = this.tooltips.findIndex(t => t.wrapper === wrapperElement);
            if (index > -1) {
                this.tooltips.splice(index, 1);
                console.log('[Tooltip] Removed tooltip');
            }
        }

        // Refresh all tooltips (useful after DOM updates)
        refresh() {
            this.tooltips = [];
            this.setup();
        }
    }

    // Helper function to create tooltip programmatically
    window.createTooltip = function(config) {
        /*
         * config = {
         *   text: 'Tooltip content text',
         *   position: 'top|bottom|left|right',
         *   theme: 'info|success|warning|error|light',
         *   size: 'small|normal|large',
         *   icon: 'fa-circle-info|fa-circle-question' // Font Awesome icon class
         * }
         */
        
        const wrapper = document.createElement('span');
        wrapper.className = 'tooltip-wrapper';
        
        if (config.position) {
            wrapper.classList.add(`tooltip-${config.position}`);
        }
        if (config.theme) {
            wrapper.classList.add(`tooltip-${config.theme}`);
        }
        
        const icon = document.createElement('i');
        icon.className = `fa-solid ${config.icon || 'fa-circle-info'} tooltip-icon`;
        icon.setAttribute('tabindex', '0');
        icon.setAttribute('aria-label', 'More information');
        
        const content = document.createElement('span');
        content.className = 'tooltip-content';
        if (config.size) {
            content.classList.add(`tooltip-${config.size}`);
        }
        content.textContent = config.text;
        content.setAttribute('role', 'tooltip');
        
        wrapper.appendChild(icon);
        wrapper.appendChild(content);
        
        return wrapper;
    };

    // Initialize tooltip manager when script loads
    window.tooltipManager = new TooltipManager();

    // Export for module systems
    if (typeof module !== 'undefined' && module.exports) {
        module.exports = TooltipManager;
    }

})();

// Usage Examples:
// 
// 1. HTML Method:
// <span class="tooltip-wrapper">
//   <i class="fa-solid fa-circle-info tooltip-icon"></i>
//   <span class="tooltip-content">This is helpful information</span>
// </span>
//
// 2. JavaScript Method:
// const tooltip = createTooltip({
//   text: 'This is helpful information',
//   position: 'top',
//   theme: 'info',
//   size: 'normal',
//   icon: 'fa-circle-info'
// });
// document.querySelector('.my-element').appendChild(tooltip);
//
// 3. Dynamic Content:
// // After adding new content with tooltips
// window.tooltipManager.refresh();
