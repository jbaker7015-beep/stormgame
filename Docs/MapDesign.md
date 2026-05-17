# Map Design

# Philosophy

StormGame uses a large-scale strategic map representing the continental United States.

The map should feel:
- recognizable
- atmospheric
- readable
- simulation-friendly

The map is not intended to be a hyper-realistic terrain simulator.

Instead, it prioritizes:
- weather gameplay
- ecosystem simulation
- performance scalability

---

# Geographic Scope

The playable map includes:
- the continental United States
- major cities
- major climate regions
- oceans
- mountains
- plains
- forests
- deserts

---

# Visual Style

The map should use:
- stylized realism
- readable terrain
- simplified large-scale geography
- atmospheric presentation

The camera should support:
- zoomed-out strategic viewing
- storm-focused close viewing

---

# State Borders

State borders should remain visible.

Purpose:
- weather alerts
- readability
- agency operations
- regional forecasting

Borders should remain subtle but clear.

---

# Major Cities

Major cities act as:
- population centers
- infrastructure hubs
- heat generators
- economic targets

Examples:
- New York
- Chicago
- Dallas
- Miami
- Los Angeles
- Seattle

Cities should vary in:
- population
- infrastructure
- climate risk

---

# Major Roads

The map should include:
- major interstate highways
- evacuation routes
- logistics corridors

Roads support:
- evacuations
- emergency response
- infrastructure gameplay

Minor roads are unnecessary.

---

# Climate Regions

The map includes realistic climate regions.

Examples:
- Tornado Alley
- Gulf Coast
- Great Plains
- Rocky Mountains
- Southwest Desert
- Great Lakes
- Pacific Northwest

Each region modifies:
- humidity
- heat
- instability
- storm potential

---

# Atmospheric Simulation Grid

The atmosphere should use region-based simulation rather than full-detail simulation.

Simulation cells store:
- humidity
- temperature
- instability
- wind
- pressure

This improves performance and scalability.

---

# Active Simulation Philosophy

Only nearby or high-impact regions should receive full simulation detail.

Distant regions use simplified background simulation.

---

# Population Simulation

Population should use:
- regional density systems
- city population values
- abstract civilian systems

Avoid simulating individual civilians globally.

---

# Destruction Simulation

Destruction should prioritize:
- major cities
- visible regions
- high-impact events

The game should avoid excessive full-scale physics simulation.

---

# Seasonal Systems

Potential future seasonal systems:
- tornado season
- hurricane season
- winter storms
- drought conditions

Seasonal changes affect atmospheric behavior.

---

# Long-Term Goals

The map should feel:
- alive
- reactive
- strategic
- atmospheric

Players should feel like they are controlling and responding to weather across a living United States ecosystem.