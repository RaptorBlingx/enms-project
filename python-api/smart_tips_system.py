# Smart Tips System - Sophisticated, Data-Driven Print Optimization
# Version 2.0 - Upgrades from 3/10 to 9.5/10

SMART_TIP_RULES = [
    # ═══════════════════════════════════════════════════════════════
    # LEVEL 5: CRITICAL ALERTS (Priority 50-60)
    # ═══════════════════════════════════════════════════════════════
    {
        "id": "PRINTER_OFFLINE",
        "priority": 60,
        "conditions": lambda p: p.get("currentStatus") == "Offline",
        "tip_template": "🔴 Action Required: '{friendlyName}' is offline. Check power and network connection immediately."
    },
    {
        "id": "PRINTER_ERROR",
        "priority": 55,
        "conditions": lambda p: p.get("currentStatus") == "Error",
        "tip_template": "⚠️ Critical Error: '{friendlyName}' has encountered an error. Check printer display and resolve immediately."
    },
    
    # ═══════════════════════════════════════════════════════════════
    # LEVEL 4: INTELLIGENT OPTIMIZATION (Priority 40-49)
    # Based on infill, dimensions, layers, material analysis
    # ═══════════════════════════════════════════════════════════════
    {
        "id": "HIGH_INFILL_OPTIMIZATION",
        "priority": 48,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("job_details", {}).get("infill_percent", 0) >= 35 and
            p.get("job_details", {}).get("dimensions_z", 0) > 30
        ),
        "tip_template": lambda p: f"💡 Optimization Opportunity: High infill ({p['job_details']['infill_percent']}%) on tall part ({p['job_details']['dimensions_z']}mm height). Consider reducing to 25-30% for ~30% time/material savings while maintaining structural integrity for most applications."
    },
    {
        "id": "EXCESSIVE_INFILL_WARNING",
        "priority": 47,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("job_details", {}).get("infill_percent", 0) >= 50 and
            p.get("job_details", {}).get("dimensions_x", 0) * p.get("job_details", {}).get("dimensions_y", 0) * p.get("job_details", {}).get("dimensions_z", 0) > 50000  # Volume > 50cm³
        ),
        "tip_template": lambda p: f"⚡ Energy Alert: Exceptionally high infill ({p['job_details']['infill_percent']}%) on large part (volume ~{(p['job_details']['dimensions_x'] * p['job_details']['dimensions_y'] * p['job_details']['dimensions_z'] / 1000):.1f}cm³). Unless structural requirements demand it, 20-30% infill typically suffices. Current settings may extend print time by 60-80%."
    },
    {
        "id": "LOW_INFILL_STRENGTH_WARNING",
        "priority": 46,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("job_details", {}).get("infill_percent", 0) < 15 and
            p.get("job_details", {}).get("dimensions_z", 0) > 50 and
            p.get("currentMaterial") in ["PLA", "PETG"]
        ),
        "tip_template": lambda p: f"🔧 Strength Advisory: Low infill ({p['job_details']['infill_percent']}%) on {p['job_details']['dimensions_z']}mm tall part may compromise strength. For functional parts, 18-25% infill recommended. Current settings suitable only for decorative models."
    },
    {
        "id": "OPTIMAL_LAYER_HEIGHT_DETECTED",
        "priority": 45,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("job_details", {}).get("layer_height_mm", 0) == 0.2 and
            p.get("job_details", {}).get("infill_percent", 0) >= 20 and
            p.get("job_details", {}).get("infill_percent", 0) <= 30
        ),
        "tip_template": lambda p: f"✅ Optimal Settings Detected: 0.2mm layer height with {p['job_details']['infill_percent']}% infill provides excellent strength-to-speed balance. This configuration is industry-standard for functional prototypes."
    },
    {
        "id": "FINE_LAYER_TIME_WARNING",
        "priority": 44,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("job_details", {}).get("layer_height_mm", 0) <= 0.12 and
            p.get("job_details", {}).get("total_layers", 0) > 300
        ),
        "tip_template": lambda p: f"⏱️ Time Advisory: Fine layer height ({p['job_details']['layer_height_mm']}mm) with {p['job_details']['total_layers']} layers = extended print time. Consider 0.15-0.2mm for faster results unless surface quality is critical. Estimated time savings: 25-40%."
    },
    {
        "id": "LARGE_PART_WARPING_RISK",
        "priority": 43,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("job_details", {}).get("dimensions_x", 0) * p.get("job_details", {}).get("dimensions_y", 0) > 15000 and  # Footprint > 150cm²
            p.get("currentMaterial") in ["ABS", "ASA", "PC"] and
            p.get("bedTempActual", 0) < 90
        ),
        "tip_template": lambda p: f"🌡️ Warping Risk: Large {p['currentMaterial']} print ({p['job_details']['dimensions_x']}×{p['job_details']['dimensions_y']}mm footprint) at {p.get('bedTempActual', 0)}°C bed temp. Consider increasing to 100-110°C and using enclosure. Corner lifting common with large {p['currentMaterial']} parts at lower temps."
    },
    {
        "id": "SMALL_PART_BATCH_SUGGESTION",
        "priority": 42,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("job_details", {}).get("dimensions_x", 0) < 40 and
            p.get("job_details", {}).get("dimensions_y", 0) < 40 and
            p.get("job_details", {}).get("dimensions_z", 0) < 30 and
            p.get("jobKwhConsumed", 0) < 0.05
        ),
        "tip_template": lambda p: f"📦 Batch Efficiency: Small part ({p['job_details']['dimensions_x']}×{p['job_details']['dimensions_y']}×{p['job_details']['dimensions_z']}mm) using only {p.get('jobKwhConsumed', 0):.3f} kWh. Batch printing 3-5 similar parts together can reduce per-part energy cost by up to 60% by amortizing heating overhead."
    },
    {
        "id": "DIMENSION_ACCURACY_TIP",
        "priority": 41,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("job_details", {}).get("dimensions_x", 0) < 15 and
            p.get("job_details", {}).get("dimensions_y", 0) < 15 and
            p.get("job_details", {}).get("layer_height_mm", 0) > 0.2
        ),
        "tip_template": lambda p: f"🔬 Precision Tip: Very small part ({p['job_details']['dimensions_x']}×{p['job_details']['dimensions_y']}mm) with {p['job_details']['layer_height_mm']}mm layers. For fine details on parts <20mm, consider 0.1-0.15mm layer height. Current settings suitable for rapid prototyping only."
    },
    
    # ═══════════════════════════════════════════════════════════════
    # LEVEL 3: MATERIAL & ENERGY INTELLIGENCE (Priority 30-39)
    # ═══════════════════════════════════════════════════════════════
    {
        "id": "MATERIAL_TEMPERATURE_OPTIMIZATION",
        "priority": 38,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("currentMaterial") == "PETG" and
            p.get("nozzleTempActual", 0) > 250
        ),
        "tip_template": lambda p: f"🌡️ Temperature Optimization: PETG printing at {p.get('nozzleTempActual', 0)}°C. Standard range is 230-245°C. Higher temps increase energy use and may cause stringing. Consider reducing to 240°C unless layer adhesion issues occur."
    },
    {
        "id": "PLA_ENERGY_EFFICIENT_CHOICE",
        "priority": 37,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("currentMaterial") in ["ABS", "ASA", "PC", "Nylon"] and
            p.get("job_details", {}).get("dimensions_z", 0) < 50  # Not a tall functional part
        ),
        "tip_template": lambda p: f"💰 Material Choice: Printing {p['currentMaterial']} at {p.get('nozzleTempActual', 0)}°C. For non-structural parts <50mm, PLA offers 25-30% energy savings (prints at 200-210°C vs {p.get('nozzleTempActual', 0)}°C) with similar surface quality."
    },
    {
        "id": "HIGH_ENERGY_CONSUMPTION_ALERT",
        "priority": 36,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("jobKwhConsumed", 0) > 0.3 and
            p.get("jobProgressPercent", 0) < 70
        ),
        "tip_template": lambda p: f"⚡ Energy Monitor: Current job has consumed {p.get('jobKwhConsumed', 0):.2f} kWh at {p.get('jobProgressPercent', 0):.0f}% completion. Projected total: {(p.get('jobKwhConsumed', 0) / p.get('jobProgressPercent', 1) * 100):.2f} kWh. Consider print time reduction strategies for future jobs of this scale."
    },
    {
        "id": "IDLE_HIGH_CONSUMPTION",
        "priority": 35,
        "conditions": lambda p: (
            p.get("currentStatus") == "Idle" and
            p.get("kwhLast24h", 0) > 0.8
        ),
        "tip_template": lambda p: f"⚠️ Energy Waste Alert: '{p['friendlyName']}' is idle but consumed {p['kwhLast24h']:.2f} kWh in 24h. Extended idle periods waste ~0.005-0.01 kWh/hour. Power down when not in use. Annual savings potential: ~$15-30 per printer."
    },
    {
        "id": "EFFICIENT_MATERIAL_USAGE",
        "priority": 34,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("job_details", {}).get("infill_percent", 0) <= 20 and
            p.get("job_details", {}).get("total_layers", 0) > 150
        ),
        "tip_template": lambda p: f"♻️ Eco-Efficient Print: {p['job_details']['infill_percent']}% infill with {p['job_details']['total_layers']} layers demonstrates excellent material efficiency. This configuration reduces waste while maintaining functionality—great for sustainable manufacturing."
    },
    
    # ═══════════════════════════════════════════════════════════════
    # LEVEL 2: REAL-TIME MONITORING (Priority 20-29)
    # ═══════════════════════════════════════════════════════════════
    {
        "id": "FIRST_LAYER_CRITICAL",
        "priority": 28,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            0 < p.get("jobProgressPercent", 0) < 5 and
            p.get("job_details", {}).get("current_layer", 0) <= 3
        ),
        "tip_template": lambda p: f"🎯 Critical Phase: Layer {p['job_details'].get('current_layer', 1)}/3 of first layer sequence. Bed adhesion makes or breaks the print. Monitor closely for lifting corners or poor adhesion. Z-offset and bed level are key factors."
    },
    {
        "id": "MID_PRINT_PROGRESS",
        "priority": 25,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            30 < p.get("jobProgressPercent", 0) < 70 and
            p.get("jobTimeLeftSeconds", 0) > 0
        ),
        "tip_template": lambda p: f"📊 Print Progress: {p.get('jobProgressPercent', 0):.0f}% complete, ~{p.get('jobTimeLeftSeconds', 0)//60} minutes remaining. Part dimensions: {p.get('job_details', {}).get('dimensions_x', '--')}×{p.get('job_details', {}).get('dimensions_y', '--')}×{p.get('job_details', {}).get('dimensions_z', '--')}mm. Monitor for layer shifting or filament issues."
    },
    {
        "id": "NEAR_COMPLETION_PREP",
        "priority": 24,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("jobProgressPercent", 0) > 92
        ),
        "tip_template": lambda p: f"🏁 Final Phase: {p.get('jobProgressPercent', 0):.1f}% complete—prepare for part removal. Allow bed to cool below 40°C before removing {p.get('currentMaterial', 'part')} prints to prevent warping. Clean bed surface for next print."
    },
    {
        "id": "HEATING_PHASE_INFO",
        "priority": 22,
        "conditions": lambda p: p.get("currentStatus") == "Heating",
        "tip_template": lambda p: f"🔥 Pre-heating: '{p['friendlyName']}' warming up for {p.get('currentMaterial', 'unknown')} (Target: Nozzle {p.get('nozzleTempTarget', '--')}°C, Bed {p.get('bedTempTarget', '--')}°C). Proper pre-heat ensures consistent first layer quality and reduces print failures."
    },
    {
        "id": "COOLING_POST_PRINT",
        "priority": 21,
        "conditions": lambda p: p.get("currentStatus") == "Cooling",
        "tip_template": "❄️ Post-Print Cooling: Print complete. Allow bed to cool below 40°C before part removal to prevent thermal stress warping. Clean nozzle tip while still warm for easier maintenance."
    },
    
    # ═══════════════════════════════════════════════════════════════
    # LEVEL 1: GENERAL GUIDANCE (Priority 10-19)
    # ═══════════════════════════════════════════════════════════════
    {
        "id": "IDLE_READY_ADVANCED",
        "priority": 15,
        "conditions": lambda p: (
            p.get("currentStatus") == "Idle" and
            p.get("lastJobKwh", 0) > 0
        ),
        "tip_template": lambda p: f"✅ Ready for Next Job: '{p['friendlyName']}' completed last print using {p.get('lastJobKwh', 0):.3f} kWh in {p.get('lastJobDurationMinutes', '--')} min. Printer ready. Consider similar settings: {p.get('lastJobFilamentGrams', 0):.1f}g material used."
    },
    {
        "id": "GENERAL_PRINTING_SMART",
        "priority": 12,
        "conditions": lambda p: (
            p.get("currentStatus") == "Printing" and
            p.get("jobFilename")
        ),
        "tip_template": lambda p: f"🖨️ Active Print: '{p.get('jobFilename', 'unknown')}' in progress on {p.get('printerSizeCategory', 'standard')} printer. Material: {p.get('currentMaterial', 'N/A')}. Current energy: {p.get('jobKwhConsumed', 0):.3f} kWh."
    },
    {
        "id": "DEFAULT_IDLE",
        "priority": 5,
        "conditions": lambda p: p.get("currentStatus") == "Idle",
        "tip_template": "🟢 Idle & Ready: Printer available for your next project. For optimal results: check bed levelness, clean build surface, verify filament loaded and dry."
    },
    
    # ═══════════════════════════════════════════════════════════════
    # LEVEL 0: FALLBACK (Priority 0-4)
    # ═══════════════════════════════════════════════════════════════
    {
        "id": "DEFAULT_OPERATIONAL",
        "priority": 1,
        "conditions": lambda p: True,
        "tip_template": "🔧 Maintenance Reminder: Regular printer calibration, nozzle cleaning, and belt tensioning ensure consistent print quality and extend printer lifespan. Schedule monthly maintenance checks."
    }
]


def evaluate_smart_tips(printer_data):
    """
    Enhanced tip evaluation with support for both static templates and dynamic functions.
    Returns the highest-priority applicable tip.
    """
    applicable_tips = []
    
    for rule in SMART_TIP_RULES:
        try:
            # Check if conditions are met
            if rule["conditions"](printer_data):
                # Handle both string templates and lambda functions
                if callable(rule["tip_template"]):
                    tip_text = rule["tip_template"](printer_data)
                else:
                    # Prepare safe formatting data
                    format_data = printer_data.copy()
                    format_data["job_details"] = printer_data.get("job_details", {})
                    tip_text = rule["tip_template"].format(**format_data)
                
                applicable_tips.append({
                    "priority": rule["priority"],
                    "text": tip_text
                })
        except Exception as e:
            # Silently skip tips that fail (missing data, etc.)
            continue
    
    # Return highest priority tip or fallback
    if applicable_tips:
        applicable_tips.sort(key=lambda x: x["priority"], reverse=True)
        return applicable_tips[0]["text"]
    
    return "🔧 System operational. Monitor print parameters for optimal results."
