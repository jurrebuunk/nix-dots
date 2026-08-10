# Design System

A modern dark interface with subtle influence from **academic typography and technical workstations**.

The interface is **modern first**. Academic and technical character comes from typography, restraint, spacing, precision, and color — never from literal scientific-paper decoration.

## Core Style

* Modern dark interface
* Minimal, practical, and functional
* Precise, structured layouts
* Strong alignment and deliberate spacing
* Transitional serif typography: **STIX Two Text**
* Technical monospace typography: **IBM Plex Mono**
* Italic/slanted typography is a recurring visual signature
* Muted, desaturated colors
* Technical blue is the primary accent
* **Absolutely no rounded corners**
* 1px structural borders
* Flat surfaces
* No decorative shadows

Avoid:

* Rounded corners
* Pills
* Gradients
* Glassmorphism
* Glow effects
* Decorative shadows
* Oversized typography
* Highly saturated colors
* Generic SaaS styling
* Excessive card layouts
* Fake figure numbers or section markers
* Formulas or scientific labels used decoratively
* Scientific-paper UI metaphors
* Retro-terminal imitation

The influence should be **felt, not imitated**.

---

## Colors

```text
Background       #1b1818
Surface          #252121
Surface Alt      #302b2b

Text             #c4c1c1
Text Muted       #918c8c
Text Faint       #777272

Border           #666262
Border Strong    #7b7676

Accent           #8aa1a8
Accent Bright    #a5bbc2
Accent Soft      #9fc7c4
Highlight        #d7ffc3

Error            #c97070
Success          #8fae9a
Warning          #c2a27d
Secondary        #9b8fa3
```

### Color Rules

`#8aa1a8` is the primary identity color.

Use it for:

* Active elements
* Links
* Selection
* Primary interaction
* Important controls

`#a5bbc2` is the stronger interaction color.

Use it for:

* Keyboard focus
* Strong active states
* Important interaction feedback

`#d7ffc3` is a rare highlight.

Do not use it as the normal accent.

Semantic colors communicate actual meaning, not decoration.

Most screens should primarily consist of:

**background + surface + text + muted text + technical blue**

---

# Typography

Typography is one of the strongest parts of the visual identity.

Use two font families:

**STIX Two Text** — human/interface language
**IBM Plex Mono** — technical/machine language

Do not introduce a generic sans-serif third family.

---

## STIX Two Text

Primary human/interface typeface.

Use for:

* General UI
* Headings
* Menus
* Buttons
* Navigation
* Window titles
* Descriptions
* Long-form text

### Italics

The STIX Two Text italic is a **major part of the visual identity**.

Use slanted/italic typography frequently for:

* Supporting UI text
* Secondary labels
* Subheadings
* Subtitles
* Descriptions
* Captions
* Annotations
* Secondary interface language

The interface should visibly contain italic typography.

However, do **not** make everything italic.

Essential information, primary body text, and important controls should normally remain regular for readability.

Think:

**Regular = primary information**
***Italic = supporting/human context***

---

## IBM Plex Mono

IBM Plex Mono should be visibly present throughout technical parts of the interface — not only inside the terminal.

Use for:

* Terminal
* Code
* Numbers
* Measurements
* Dates
* Times
* File paths
* IP addresses
* Keyboard shortcuts
* Commands
* Logs
* System information
* Machine-generated values
* Technical metadata

Example:

```text
Temperature        47.2 °C
Uptime             16:43:08
Interface          enp4s0
Address            192.168.1.42
Config             /etc/nixos/configuration.nix
```

These values should visually contrast with the surrounding STIX interface typography.

IBM Plex Mono Italic may be used for **secondary technical metadata or machine labels**.

Regular IBM Plex Mono remains preferred for:

* Values
* Code
* Commands
* Paths
* Exact machine information

Do not use monospace randomly as decoration.

---

## Typography Roles

```text
Display
STIX Two Text
24–28px
Regular

Heading
STIX Two Text
18–20px
Regular / Medium

Subheading
STIX Two Text
16–18px
Italic preferred

Body / UI
STIX Two Text
15–16px
Regular

Supporting UI
STIX Two Text
13–15px
Italic preferred

Label
STIX Two Text
14px
Regular or Italic

Caption / Description
STIX Two Text
13px
Italic

Technical Metadata
IBM Plex Mono
12–13px
Regular or Italic

Terminal
IBM Plex Mono
14–15px
Regular

Code / Values
IBM Plex Mono
Context dependent
Regular
```

Prefer regular and medium weights.

Avoid excessive bold typography.

Create hierarchy through:

* Serif vs monospace
* Regular vs italic
* Size
* Spacing
* Alignment
* Color

### Italic Rule

Slanted typography is a recurring signature of the interface.

It should be **clearly visible throughout the system**, particularly in secondary and supporting language.

It must still serve hierarchy and readability rather than becoming decoration.

---

# Geometry

All UI geometry is square.

```text
Corner radius    0px
Border           1px default
Focus outline    2px permitted
Shadow           none
```

**Never introduce rounded corners.**

This applies to:

* Windows
* Panels
* Buttons
* Inputs
* Menus
* Dialogs
* Notifications
* Tooltips
* Cards
* Tabs
* Selection indicators
* Progress elements

### Border Weight

Use **1px** for normal structural borders and separators.

This keeps square components precise and restrained.

Use **2px only for meaningful emphasis**, primarily keyboard focus or exceptional active states.

Prefer an outline so the thicker focus state does not alter component dimensions.

---

# Layout

Layouts should feel structured, calm, compact, and precise.

Prefer:

* Strong alignment
* Consistent spacing
* Thin separators
* Flat surfaces
* Clear visual hierarchy
* Compact controls
* Information density without clutter

Use borders only when they communicate structure.

Use whitespace, alignment, typography, and surface changes before introducing another container.

Avoid placing every piece of information inside its own card.

---

# Components

Components must remain recognizably **modern UI components**.

A button should look like a button.

A menu should look like a menu.

A settings page should look like a settings page.

Do not transform components into scientific-paper or retro-computer metaphors.

The academic and technical character should emerge naturally from:

* Typography
* Italics
* Serif/monospace contrast
* Palette
* Square geometry
* Precision
* Restraint

## Interaction States

```text
Default     neutral
Hover       subtle surface change
Active      #8aa1a8
Focus       #a5bbc2 + optional 2px outline
Disabled    muted / faint
Error       #c97070
Success     #8fae9a
Warning     #c2a27d
```

Animations should be subtle, short, and functional.

---

# Terminal Palette

```text
black          #1b1818
red            #c97070
green          #8fae9a
yellow         #c2a27d
blue           #8aa1a8
magenta        #9b8fa3
cyan           #9fc7c4
white          #c4c1c1

brightBlack    #777272
brightRed      #df8a8a
brightGreen    #a9c9b4
brightYellow   #d8bb96
brightBlue     #a5bbc2
brightMagenta  #b7aabd
brightCyan     #badeda
brightWhite    #e5e2e2
```

```text
Foreground     #c4c1c1
Background     #1b1818
Cursor         #a5bbc2
```

---

# Guiding Principle

The interface is **modern first**.

Academic and old technical influences provide personality through:

**typography + italics + muted colors + square geometry + precision + restraint**

It should never literally look like:

* A scientific paper
* A retro terminal
* An old operating system
* A themed imitation of an old computer

The historical influence should be subtle enough that the interface still feels contemporary.

**Modern interface. Old-school discipline.**
::: 
