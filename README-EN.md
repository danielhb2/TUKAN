# 🦜 TUKAN(ban) - TU KANBAN (CLI)
> It's a play on words in Spanish:  
TU (your) KAN(ban) 🦜

[![Bash](https://img.shields.io/badge/bash-5.0+-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-blue.svg)]()  [![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

> Please excuse my (zero) English. This readme was translated by AI.  
> This project is entirely in Spanish, sorry, you can collaborate by translating it or making it multilingual.

---
> **Kanban-style note manager with powerful and interactive TUI (Terminal User Interface)**  
> 
> This project is an extension/fork of FuzPad by JianZcar - https://github.com/JianZcar/FuzPad.
> This project is entirely in Spanish, sorry. You can help by translating it or making it multilingual.
---

## 📋 TABLE OF CONTENTS

1. [What is TUKAN?](#what-is-tukan)
2. [Features](#features)
3. [Requirements](#requirements)
4. [Installation](#installation)
5. [File Structure](#file-structure)
6. [Basic Usage](#basic-usage)
7. [Main Functions](#main-functions)
8. [Note Format](#note-format)
9. [Tag System](#tag-system)
10. [Directories](#directories)
11. [Search](#search)
12. [Statistics](#statistics)
13. [Configuration](#configuration)
14. [Keyboard Shortcuts](#keyboard-shortcuts)
15. [Modular Architecture](#modular-architecture)
16. [Troubleshooting](#troubleshooting)
17. [Tips and Tricks](#tips-and-tricks)

---
<a name="what-is-tukan"></a>
## 🎯 What is TUKAN?

TUKAN is a complete Kanban-style note management system that runs entirely in the terminal. It combines Kanban methodology with a flexible Markdown note system, real-time interactive search, and a modern visual interface using `fzf`.

**Philosophy:**
- **Simple**: Plain markdown files
- **Fast**: Keyboard navigation
- **Visual**: Real-time previews
- **Portable**: Text files only
- **No dependencies**: No database required

---
<a name="features"></a>
## ✨ Features

### 🎨 Interface
- ✅ Interactive menu with `fzf`
- ✅ Real-time note preview
- ✅ Colored visualization with markdown formatting
- ✅ Complete keyboard navigation

### 📝 Note Management
- ✅ Create notes with automatic timestamp
- ✅ Edit notes with your favorite editor
- ✅ Organize in Kanban-style directories
- ✅ Move notes between directories
- ✅ Delete notes with confirmation
- ✅ Complete metadata (dates, size, tags)

### 🔍 Search and Filtering
- ✅ Real-time search (names and content)
- ✅ Filter by tags (#hashtags)
- ✅ Match highlighting
- ✅ Preview with context

### 📊 Statistics
- ✅ Notes by date
- ✅ Notes by directory
- ✅ Time filters (today, yesterday, week, month)
- ✅ System overview

### 🏷️ Tags
- ✅ Hashtag system (#tag)
- ✅ Multiple tags per note
- ✅ Search by tags with counter
- ✅ Note preview by tag
- ✅ Metadata visualization

---
<a name="requirements"></a>
## 📦 Requirements

### Required
- `bash` (4.0+)
- `fzf` (0.27+) - Interactive fuzzy finder
- `find`, `grep`, `sed`, `awk` - Standard Unix tools
- `bc` - Basic calculator (for file size calculation)

### Optional (for enhanced visualization)
- `bat` - Syntax highlighting with line numbers
- `mdcat` - Markdown rendering in terminal (recommended)
- `mdless` - Rendering with pagination

### Dependency Installation

**Ubuntu/Debian:**
```bash
sudo apt install fzf bat bc
cargo install mdcat
```

**macOS:**
```bash
brew install fzf bat bc
brew install mdcat
```

**Arch Linux:**
```bash
sudo pacman -S fzf bat bc
cargo install mdcat
```

---
<a name="installation"></a>
## 🚀 Installation

### 1. Download TUKAN

```bash
# Create directory
mkdir -p ~/tukan
cd ~/tukan

# Download files
# tukan.sh + all modules in functions/
```

### 2. Directory structure

```bash
# Create subdirectory for modules
mkdir -p functions

# Place files:
# tukan.sh in ~/tukan/
# *.sh in ~/tukan/functions/
```

### 3. Set execution permissions

```bash
chmod +x tukan.sh
chmod +x functions/*.sh
```

### 4. Run

```bash
./tukan.sh
```

### 5. Add to PATH (optional)

```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$HOME/tukan:$PATH"

# Reload
source ~/.bashrc

# Now you can run from anywhere:
tukan.sh
```

---
<a name="file-structure"></a>
## 📁 File Structure

### System structure

```
~/tukan/                          # TUKAN installation
├── tukan.sh                      # Main script
└── functions/                    # Modules
    ├── utils.sh                  # Helper functions
    ├── actions.sh                # Action menu
    ├── help.sh                   # Help system
    ├── search.sh                 # Search
    ├── tags.sh                   # Tags
    ├── notes.sh                  # Create/open notes
    ├── directories.sh            # Directory management
    ├── move.sh                   # Move notes
    ├── stats.sh                  # Statistics
    └── delete.sh                 # Delete notes

~/Documents/.TUKAN/               # Data directory
├── 1-Ideas/                      # New ideas
├── 2-En_curso/                # Tasks in progress
├── 3-Completado/                  # Completed tasks
├── 4-Cancelado/                   # Canceled tasks
├── 5-Proyectos_futuros/            # Backlog
├── 6-Notas_varias/               # Miscellaneous notes
├── Basurero/                        # Recycle bin
├── note1.md                      # Notes in root
└── ...                           # More notes

📁 Configuration file

~/.config/tukan/tukan.conf
```

### Data location

By default, notes are saved in:
```
~/Documents/.TUKAN/
```

You can change this location with the environment variable:
```bash
export TUKAN_DIR="$HOME/my-notes"
```

---
<a name="basic-usage"></a>
## 📖 Basic Usage

### Start TUKAN

```bash
./tukan.sh
```

The main menu will open with the following options:

```
┌─────────────────────────────────────┐
│ 📕 Nueva                            │
│ 📖 Abrir                            │
│ 🏷 Etiquetas                         │
│ 🔎 Buscar                           │
│ 📁 Directorios                      │
│ 📦 Mover                            │
│ 📊 Estadísticas                     │
│ ❓ Ayuda                            │
│ 🔥 Borrar                           │
│ 💎 Salir                            │
└─────────────────────────────────────┘
This means
┌─────────────────────────────────────┐
│ 📕 New                              │
│ 📖 Open                             │
│ 🏷 Tags                             │
│ 🔎 Search                           │
│ 📁 Directories                      │
│ 📦 Move                             │
│ 📊 Statistics                       │
│ ❓ Help                             │
│ 🔥 Delete                           │
│ 💎 Exit                             │
└─────────────────────────────────────┘
```

### Basic navigation

- **↑/↓**: Navigate between options
- **Enter**: Select option
- **Esc**: Go back / Exit
- **Tab**: Multiple selection (where applicable)

---
<a name="main-functions"></a>
## 🎯 Main Functions

### 📕 New Note

Creates a new note with automatic timestamp.

**Flow:**
1. Select destination directory
2. Editor opens with template
3. Write your note
4. Save and close editor

**Automatic name:**
```
DD-MM-YYYY-HH-MM-SS.md
Example: 27-01-2025-21-55-01.md
```

**Default template:**
```markdown
# Note Title
#tag1 #tag2

Note content...
```

---

### 📖 Open Note

Opens and edits existing notes.

**Features:**
- Lists all system notes
- Real-time preview
- Interactive search (type to filter)
- Complete metadata visible

**Metadata displayed:**
```
┌────────────────────────── METADATA ─────────────────────────┐
│ 27-01-2025-21-55-01.md
│ Directory: 2-In_progress
│ Created: 27-01-2025 21:55:01
│ Modified: 28-01-2025 10:30:15
│ Size: 3.47 KB
│ Tags: #project #important
└─────────────────────────────────────────────────────────────┘

═══ Title ═══
My Important Project

═══ Content ═══
Project description...
```

**Action menu:**
When selecting a note (Enter):
- **Edit**: Open in editor
- **Move to another directory**: Change location
- **Delete**: Remove note
- **Cancel**: Go back

---

### 🏷 Tags

Search and filter notes by hashtags.

**Features:**
- Lists all used tags
- Note counter per tag
- Note preview with that tag
- Quick access to related notes

**Example:**
```
#project (15 notes)
#important (8 notes)
#personal (23 notes)
#work (42 notes)
```

**Flow:**
1. Select tag
2. See list of notes with that tag
3. Select note to see action menu

---

### 🔎 Search

Real-time search in names and content.

**Features:**
- Incremental search (results as you type)
- Search in file names
- Search in note content
- Match highlighting
- Preview with context

**Flow:**
1. Type your search (minimum 2 characters)
2. Results appear automatically
3. Navigate through results
4. Enter to see action menu

**Result format:**
```
L42      ║ This is the text with the match...     ║ note.md
FILE     ║ Match in name                          ║ 27-01-2025.md
```

**Preview shows:**
- Complete metadata
- Exact line with match highlighted
- Context (lines before and after)

---

### 📁 Directories

Manages folder structure.

**Options:**
- **Create new directory**: Add new category
- **List existing directories**: See current structure

**Predefined directories:**
- `1-Ideas`: New ideas and concepts
- `2-En_curso`: Tasks in progress
- `3-Completado`: Completed tasks
- `4-Cancelado`: Discarded tasks
- `5-Future_projects`: Backlog
- `6-Notas_varias`:  Miscellaneous notes
- `Basurero`: Recycle bin
- `[Base]`: Root directory (uncategorized)

---

### 📦 Move

Reorganizes notes between directories.

**Flow:**
1. Select note to move
2. Note preview
3. Select destination directory
4. Automatic confirmation

**Useful for:**
- Move idea to "In progress"
- Archive completed task
- Clean and organize
- Kanban workflow

---

### 📊 Statistics

Overview and system analysis.

**Options:**

#### Overview
Summary of notes by directory:
```
▌ Ideas (5 notes)
────────────────────────────────────
  • New functionality for...
  • Research about...
  • Improvement proposal...
  ... and 2 more

▌ In progress (12 notes)
────────────────────────────────────
  • Project X - Phase 1
  • Documentation of...
  • Implement feature Y
  ... and 9 more
```

#### Notes by Date
Explore notes created on specific dates:
- List of dates with counter
- Preview by date
- Quick access to notes

#### Notes by Period
Quick time filters:
- **Today**: Notes created today
- **Yesterday**: Yesterday's notes
- **This week**: Last 7 days
- **This month**: Current month
- **Total**: All system notes

---

### 🔥 Delete

Deletes notes with mandatory confirmation.

**Features:**
- Multiple selection (Tab)
- Preview before deleting
- Explicit confirmation
- Irreversible action

**Flow:**
1. Select note(s) to delete (Tab for multiple)
2. Preview of what will be deleted
3. Type "YES" or "Y" in UPPERCASE
4. Deletion confirmation

**Visible warning:**
```
╔═══════════════════════════════════════════════════════════╗
║  WARNING: CANNOT BE UNDONE - CONFIRM WITH S or SI         ║
╚═══════════════════════════════════════════════════════════╝
```

---

### ❓ Help

Help system with sections.

**Available topics:**
- **General Navigation**: Basic controls
- **Main Options**: All functions
- **Shortcuts**: Keyboard commands
- **Note Format**: Recommended structure
- **Subdirectories**: Organization
- **Tips**: Tips and tricks
- **All**: Complete help

---
<a name="note-format"></a>
## 📝 Note Format

### Recommended structure

```markdown
# Note title
#tag1 #tag2 #tag3

## Section 1

Section content...

## Section 2

More content...

- Item list
- Another item

**Bold text**
*Italic text*
`inline code`

```bash
# Code block
command
```
```

### Note anatomy

**Line 1**: Main title
```markdown
# My Important Project
```

**Line 2**: Tags (optional)
```markdown
#project #work #urgent
```

**Line 3+**: Content
```markdown
Project description...
```

### Best practices

✅ **Use descriptive titles**
```markdown
# Implement authentication system
```

✅ **Tag appropriately**
```markdown
#development #backend #security
```

✅ **Structure with sections**
```markdown
## Objective
## Requirements
## Implementation
## Notes
```

✅ **Use lists for tasks**
```markdown
- [ ] Pending task
- [x] Completed task
```

---
<a name="tag-system"></a>
## 🏷️ Tag System

### Syntax

**Format:**
```markdown
#tag
```

**Rules:**
- Starts with `#`
- No spaces
- Letters, numbers, hyphens: `#my-tag_123`
- Case-sensitive: `#Project` ≠ `#project`

### Location

**Second line of file:**
```markdown
# Title
#tag1 #tag2 #tag3

Content...
```

### Usage examples

**By context:**
```markdown
#work #personal #study
```

**By project:**
```markdown
#project-x #phase-1 #development
```

**By priority:**
```markdown
#urgent #important #low-priority
```

**By type:**
```markdown
#idea #task #note #reference
```

**Combined:**
```markdown
#work #project-x #urgent #development
```

### Tag search

1. Go to **🏷 Tags**
2. Select tag
3. See filtered notes
4. Access specific note

---
<a name="directories"></a>
## 📂 Directories

### Predefined directories

#### 1-Ideas
**Purpose**: Capture new ideas
**Use**: Brainstorming, initial concepts
```
Ideas for new projects
Concepts to research
Proposals without development
```

#### 2-En_curso
**Purpose**: Active work
**Use**: Tasks in development
```
Active projects
Tasks in progress
Day-to-day work
```

#### 3-Completado
**Purpose**: Completed archive
**Use**: Achievement history
```
Finished projects
Completed tasks
Historical reference
```

#### 4-Cancelado
**Purpose**: Discarded
**Use**: Non-viable ideas
```
Canceled projects
Discarded ideas
Obsolete tasks
```

#### 5-Proyectos_futuros
**Purpose**: Backlog
**Use**: Future planning
```
Ideas for next sprints
Planned projects
Long-term goals
```

#### 6-Notas_varias
**Purpose**: anything
```
Miscellaneous notes
```

#### Basurero
**Purpose**: Recycle bin
**Use**: Before definitive deletion
```
Notes to review for deletion
Temporary content
Pending cleanup
```

#### [Base]
**Purpose**: Uncategorized
**Use**: Quick notes, unclassified
```
Temporary notes
No specific category
Quick entry
```

### Create custom directories

1. Go to **📁 Directories**
2. Select "Create new directory"
3. Enter name
4. Confirm

**Custom directory examples:**
```
Clients/
Projects/
  ├── Project-A/
  ├── Project-B/
  └── Project-C/
References/
Templates/
```

---
<a name="search"></a>
## 🔍 Search

### Search types

#### Search by name
Finds files whose name contains the term:
```
Search: "27"
Result: 27-01-2025-21-55-01.md
```

#### Search by content
Finds notes containing the text:
```
Search: "project"
Result: All notes with "project" in content
```

#### Combined search
TUKAN searches both simultaneously.

### Search tips

**Short terms (2-3 characters):**
```
"27" → Finds dates, numbers
"md" → Finds markdown files
"py" → Finds Python code
```

**Complete words:**
```
"project" → Notes about projects
"urgent" → Urgent tasks
"backend" → Backend development
```

**Dates:**
```
"27-01" → Notes from January 27th
"2025" → Notes from year 2025
"01-2025" → Notes from January 2025
```

### Result navigation

- **↑/↓**: Navigate results
- **Enter**: Open action menu
- **Esc**: Exit search
- **Ctrl+X/Z**: Scroll in preview
- **Ctrl+A/S**: Line by line scroll

### Result format

```
L42      ║ Text where the search appears...       ║ file.md
FILE     ║ Match in name                          ║ 27-01-2025.md
```

**L42**: Line 42 of file
**FILE**: Match in file name

---
<a name="statistics"></a>
## 📊 Statistics

### Overview

Shows summary of all directories:

```
▌ Ideas (5 notes)
────────────────────────────────────
  • Implement feature X
  • Research technology Y
  • Improvement proposal Z
  ... and 2 more

▌ In progress (12 notes)
────────────────────────────────────
  • Project A - Phase 1
  • System documentation
  • Critical bug fix
  ... and 9 more
```

**Information shown:**
- Directory name
- Note counter
- Preview of last 3 notes
- More notes indicator

### Notes by Date

Chronological creation list:

```
27-01-2025 (5 notes)
26-01-2025 (3 notes)
25-01-2025 (8 notes)
...
```

**Flow:**
1. Select date
2. See notes from that date
3. Individual preview
4. Access to action menu

### Notes by Period

Quick time filters:

#### Today
Notes created today
```
Useful for: Review day's work
```

#### Yesterday
Notes created yesterday
```
Useful for: Continuous tracking
```

#### This week
Last 7 days
```
Useful for: Weekly review
```

#### This month
Current month
```
Useful for: Monthly view, reports
```

#### Total
All system notes
```
Useful for: Complete view, general search
```

---
<a name="configuration"></a>
## ⚙️ Configuration

TUKAN uses an **external configuration file** to facilitate customization without modifying source code.

### 📁 Configuration File

**Location:** `~/.config/tukan/tukan.conf`

TUKAN automatically searches for this file at startup. If it doesn't exist, it uses default values.

#### Create configuration

```bash
# Create configuration directory
mkdir -p ~/.config/tukan

# Create configuration file
nano ~/.config/tukan/tukan.conf
```

#### Example tukan.conf

```bash
# ============================================================================
# TUKAN CONFIGURATION
# ============================================================================

# ----------------------------------------------------------------------------
# DIRECTORIES AND FORMATS
# ----------------------------------------------------------------------------
TUKAN_DIR="$HOME/Documents/.TUKAN"
TUKAN_TEXT_FORMAT="md"
EDITOR="nano"
TUKAN_DATE_TIME_FORMAT="%d-%m-%Y-%H-%M-%S"

# ----------------------------------------------------------------------------
# INTERFACE
# ----------------------------------------------------------------------------
TUKAN_ICON=1
TUKAN_REVERSE_LIST=false
TUKAN_PREVIEW_SIZE="70%"
TUKAN_START_LINE_SEARCH_PREVIEW=5
TUKAN_END_LINE_SEARCH_PREVIEW=9999

# ----------------------------------------------------------------------------
# MARKDOWN VIEWER
# ----------------------------------------------------------------------------
VISOR="mdcat"           # Options: bat, mdcat, mdless, cat
VISOR_STYLE="numbers,grid"  # Only for bat

# ----------------------------------------------------------------------------
# COLOR THEMES
# ----------------------------------------------------------------------------
# Define your custom themes here

BLUE="label:#f2ff00,fg:7,bg:#000080,hl:2,fg+:15,bg+:2,hl+:14,info:3,prompt:2,pointer:#000000,marker:1,spinner:6,border:7,header:2:bold,preview-fg:7,preview-bg:#000000,preview-border:#ffff00"

GREEN="label:#00ff88,fg:7,bg:#001a00,hl:#00ff00,fg+:#ffffff,bg+:#003300,hl+:#88ff00,info:#00cc88,prompt:#00ff88,pointer:#00ff00,marker:#00ff88,spinner:#00cc66,border:#008800,header:#00ff88:bold,preview-fg:#aaffaa,preview-bg:#002200,preview-border:#00ff88"

MATRIX="label:#00ff00,fg:#aaffaa,bg:#000f00,hl:#00ff88,fg+:#ffffff,bg+:#002200,hl+:#88ff00,info:#00aa00,prompt:#00ff00,pointer:#00ff88,marker:#00ff00,spinner:#008800,border:#004400,header:#00ff00:bold,preview-fg:#88ff88,preview-bg:#001900,preview-border:#00aa00"

DARK="label:#00ffff,fg:7,bg:#1a1a2e,hl:3,fg+:15,bg+:3,hl+:14,info:6,prompt:4,pointer:#ff00ff,marker:2,spinner:5,border:8,header:4:bold,preview-fg:7,preview-bg:#0f3460,preview-border:#00ffff"

LIGHT="label:#000080,fg:0,bg:#f0f0f0,hl:4,fg+:0,bg+:4,hl+:1,info:6,prompt:2,pointer:#000000,marker:1,spinner:6,border:0,header:2:bold,preview-fg:0,preview-bg:#ffffff,preview-border:#000080"

PURPLE="label:#ff79c6,fg:7,bg:#282a36,hl:5,fg+:15,bg+:5,hl+:13,info:6,prompt:13,pointer:#bd93f9,marker:13,spinner:6,border:5,header:13:bold,preview-fg:7,preview-bg:#44475a,preview-border:#ff79c6"

# ----------------------------------------------------------------------------
# ACTIVE THEME (choose one from above or leave empty for default)
# ----------------------------------------------------------------------------
TEMA_ACTIVO="BLUE"
this means
ACTIVE_THEME="BLUE"
```

### 🎨 Included Color Themes

TUKAN includes multiple predefined themes:

#### Dark Themes
- **BLUE** - Classic navy blue (default)
- **GREEN** - Forest green
- **MATRIX** - Matrix green
- **DARK** - Modern dark
- **PURPLE** - Dracula-like purple
- **MOKSHA** - Mystical purple

#### Light Themes
- **LIGHT** - Minimalist light background
- **WATER_CLEAR** - Soft aqua
- **WATER_FRESH** - Light cyan
- **YETI** - Blue on white
- **YETI_SOFT** - Soft YETI
- **YETI_DARK** - Darkened YETI
- **YETI_MUTED** - Muted YETI

#### Earth Themes
- **FOREST** - Olive green
- **OLIVE** - Natural olive
- **DESERT_OCHRE** - Sand orange
- **CHOCOLATE** - Warm brown
- **CLAY** - Terracotta
- **HONEY** - Golden yellow
- **LEATHER** - Leather brown

#### Native Theme
- **NATIVE** - Uses terminal colors

### 🔧 Advanced Customization

#### Create your own theme

```bash
# In ~/.config/tukan/tukan.conf

# Define your custom theme
MY_THEME="label:#ff00ff,fg:7,bg:#001122,hl:3,fg+:15,bg+:3,hl+:14,info:6,prompt:4,pointer:#00ffff,marker:2,spinner:5,border:8,header:4:bold,preview-fg:7,preview-bg:#002233,preview-border:#ff00ff"

# Activate it
ACTIVE_THEME="MY_THEME"
```

#### fzf color components

fzf themes are defined with these components:

| Component | Description |
|-----------|-------------|
| `label` | Border label |
| `fg` | Main text |
| `bg` | Main background |
| `hl` | Match highlight |
| `fg+` | Selected text |
| `bg+` | Selected background |
| `hl+` | Selected highlight |
| `info` | Information (counter) |
| `prompt` | Prompt symbol |
| `pointer` | Selection pointer |
| `marker` | Marker (Tab) |
| `spinner` | Loading spinner |
| `border` | Border lines |
| `header` | Header lines |
| `preview-fg` | Preview text |
| `preview-bg` | Preview background |
| `preview-border` | Preview border |

**Colors:** Use ANSI codes (0-255) or hexadecimal (#RRGGBB)

#### Configurable variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TUKAN_DIR` | Notes directory | `~/Documents/.TUKAN` |
| `TUKAN_TEXT_FORMAT` | File extension | `md` |
| `EDITOR` | Text editor | `nano` |
| `TUKAN_DATE_TIME_FORMAT` | Date/time format | `%d-%m-%Y-%H-%M-%S` |
| `TUKAN_ICON` | Show icons (0/1) | `1` |
| `TUKAN_REVERSE_LIST` | Reverse order | `false` |
| `TUKAN_PREVIEW_SIZE` | Preview size | `70%` |
| `VISOR` | Markdown viewer | `mdcat` |
| `VISOR_STYLE` | bat style | `numbers,grid` |
| `ACTIVE_THEME` | Active color theme | `BLUE` |

### Apply changes

```bash
# Changes apply when restarting TUKAN
./tukan.sh

# Or restart terminal if using environment variables
```

---
<a name="keyboard-shortcuts"></a>
## ⌨️ Keyboard Shortcuts

### General navigation

| Key | Action |
|-----|--------|
| `↑` / `↓` | Navigate options |
| `Enter` | Select |
| `Esc` | Go back / Cancel |
| `Tab` | Multiple selection |
| `Ctrl+C` | Force exit |

### In preview

| Key | Action |
|-----|--------|
| `Ctrl+X` | Page up |
| `Ctrl+Z` | Page down |
| `Ctrl+A` | Line up |
| `Ctrl+S` | Line down |

### In search

| Key | Action |
|-----|--------|
| Type | Real-time search |
| `↑` / `↓` | Navigate results |
| `Enter` | Open note |
| `Esc` | Exit search |

### In lists

| Key | Action |
|-----|--------|
| Type | Filter list |
| `Tab` | Mark item |
| `Shift+Tab` | Unmark item |

---
<a name="modular-architecture"></a>
## 🏗️ Modular Architecture

### System structure

```
tukan/
├── tukan.sh              # Main script (300 lines)
│   ├── Configuration
│   ├── Module loading
│   └── Main menu
└── functions/            # Modules (1100 lines)
    ├── utils.sh          # Helper functions (170 lines)
    ├── actions.sh        # Action menu (52 lines)
    ├── help.sh           # Help system (230 lines)
    ├── search.sh         # Search (160 lines)
    ├── tags.sh           # Tags (66 lines)
    ├── notes.sh          # Create/open (78 lines)
    ├── directories.sh    # Directories (80 lines)
    ├── move.sh           # Move notes (63 lines)
    ├── stats.sh          # Statistics (340 lines)
    └── delete.sh         # Delete (68 lines)

📁 Configuration file

~/.config/tukan/tukan.conf
```

### Responsibilities

#### tukan.sh (Main)
- Global configuration
- Environment variables
- Module loading
- Main menu
- Initialization

#### utils.sh (Base)
- Helper functions
- Get title
- Get tags
- Format dates
- Render icons
- Kanban preview

#### actions.sh
- Note action menu
- Edit
- Move
- Delete
- Cancel

#### help.sh
- Help system
- Documentation
- Section navigation

#### search.sh
- Real-time search
- File names
- Note content
- Preview with context

#### tags.sh
- List tags
- Filter by tag
- Usage counter

#### notes.sh
- Create new note
- Open existing note
- Directory selection

#### directories.sh
- Create directories
- List structure
- Content preview

#### move.sh
- Move notes
- Destination selection
- Confirmation

#### stats.sh
- Overview
- Notes by date
- Notes by period
- Global statistics

#### delete.sh
- Delete notes
- Multiple selection
- Mandatory confirmation

### Loading flow

```
1. tukan.sh starts
2. Load configuration
3. Load utils.sh (base)
4. Load actions.sh
5. Load remaining modules
6. Initialize directories
7. Show main menu
```

### Advantages of modularization

✅ **Maintenance**
- Each module is independent
- Easy to locate bugs
- Modify without affecting others

✅ **Development**
- Work on specific modules
- Isolated testing
- Code reuse

✅ **Scalability**
- Add new modules
- Extend functionality
- Custom plugins

✅ **Clarity**
- Organized code
- Clear responsibilities
- Easy to understand

---
<a name="troubleshooting"></a>
## 🔧 Troubleshooting

### TUKAN doesn't start

**Symptom**: Error when running `./tukan.sh`

**Solution 1**: Check permissions
```bash
chmod +x tukan.sh
chmod +x functions/*.sh
```

**Solution 2**: Check structure
```bash
ls -la
ls -la functions/
# Should show tukan.sh and functions/*.sh
```

**Solution 3**: Check dependencies
```bash
command -v fzf
# Should show: /usr/bin/fzf or similar

# If not installed:
sudo apt install fzf  # Ubuntu/Debian
brew install fzf      # macOS
```

---

### Error: "Module X not found"

**Symptom**: Error message when loading modules

**Cause**: Missing files in `functions/`

**Solution**: Check all modules
```bash
ls functions/
# Should list:
# utils.sh actions.sh help.sh search.sh
# tags.sh notes.sh directories.sh move.sh
# stats.sh delete.sh

# If any missing, download it
```

---

### Preview not displaying correctly

**Symptom**: Empty preview or strange characters

**Cause**: Viewer not installed or misconfigured

**Solution 1**: Change viewer in tukan.conf
```bash
# Edit ~/.config/tukan/tukan.conf
VISOR="cat"  # Most basic, always works
```

**Solution 2**: Install viewer
```bash
# mdcat (recommended)
cargo install mdcat

# bat
sudo apt install bat  # Ubuntu/Debian
brew install bat      # macOS
```

---

### Special characters displayed incorrectly

**Symptom**: Strange symbols instead of Unicode characters

**Cause**: Terminal doesn't support UTF-8

**Solution**: Configure locale
```bash
# Check current locale
locale

# Configure UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Add to ~/.bashrc for persistence
echo 'export LANG=en_US.UTF-8' >> ~/.bashrc
echo 'export LC_ALL=en_US.UTF-8' >> ~/.bashrc
```

---

### Search doesn't find results

**Symptom**: Search shows no existing files

**Solution 1**: Check directory
```bash
ls ~/Documents/.TUKAN/
# Should show your notes

# If empty or doesn't exist:
mkdir -p ~/Documents/.TUKAN
```

**Solution 2**: Check TUKAN_DIR
```bash
echo $TUKAN_DIR
# Should show: /home/user/Documents/.TUKAN

# If misconfigured:
export TUKAN_DIR="$HOME/Documents/.TUKAN"
```

**Solution 3**: Search with more characters
```bash
# Minimum 2 characters
# "a" → Doesn't search
# "ab" → Searches
```

---

### Editor doesn't open

**Symptom**: Nothing happens when selecting "Edit"

**Cause**: Editor not configured or not installed

**Solution 1**: Check editor
```bash
echo $EDITOR
command -v $EDITOR
```

**Solution 2**: Configure editor
```bash
# In tukan.conf
EDITOR=nano

# Or use environment variable
export EDITOR=nano
```

**Solution 3**: Install editor
```bash
sudo apt install nano  # Ubuntu/Debian
brew install nano      # macOS
```

---

### Notes not saving

**Symptom**: Changes don't persist

**Cause**: Write permissions

**Solution**: Check permissions
```bash
ls -la ~/Documents/.TUKAN/
# Should show: drwxr-xr-x

# If no permissions:
chmod -R u+w ~/Documents/.TUKAN/
```

---

### FZF closes unexpectedly

**Symptom**: Menu closes when pressing certain keys

**Cause**: Shortcut conflict

**Solution**: Avoid these keys
- Don't use `Ctrl+C` (closes TUKAN)
- Use `Esc` to go back
- `Enter` to confirm

---

### Color theme not working

**Symptom**: Error "invalid color specification"

**Cause**: Theme variable not expanded correctly

**Solution**: Check tukan.conf
```bash
# Make sure you're using the theme name, not the value
ACTIVE_THEME="BLUE"  # ✅ Correct
ACTIVE_THEME="label:#f2ff00..."  # ❌ Incorrect
```

---
<a name="tips-and-tricks"></a>
## 💡 Tips and Tricks

### Recommended Workflow

#### GTD Method (Getting Things Done)

**1. Capture (Ideas)**
```bash
📕 New → Select "1-Ideas"
Write quick idea
Tag appropriately
```

**2. Process (Classification)**
```bash
📖 Open → Review ideas
📦 Move → Classify by priority
```

**3. Organize (Categorization)**
```bash
🏷 Tags → Group by context
#work #personal #urgent
```

**4. Execute (In progress)**
```bash
📦 Move → To "2-In_progress"
📖 Open → Work on task
```

**5. Review (Statistics)**
```bash
📊 Statistics → See progress
Review completed
Adjust planning
```

---

### Organization by Projects

**Create structure:**
```bash
📁 Directories → Create
Projects/
  ├── Project-A/
  ├── Project-B/
  └── Project-C/
```

**Use combined tags:**
```markdown
#project-a #phase-1 #development
#project-b #design #urgent
```

**Move between phases:**
```
Ideas → In progress → Completed
```

---

### Priority System

**Use tags:**
```markdown
#p1-urgent     # High priority
#p2-important  # Medium priority
#p3-normal     # Low priority
```

**Search by priority:**
```bash
🏷 Tags → #p1-urgent
See all urgent ones
```

---

### Backup and Synchronization

**Manual backup:**
```bash
# Copy everything
cp -r ~/Documents/.TUKAN ~/backup/tukan-$(date +%Y%m%d)

# Compress
tar -czf tukan-backup.tar.gz ~/Documents/.TUKAN
```

**Git synchronization:**
```bash
cd ~/Documents/.TUKAN
git init
git add .
git commit -m "Backup $(date +%Y-%m-%d)"
git push origin main
```

**Dropbox/Drive synchronization:**
```bash
# Change location
export TUKAN_DIR="$HOME/Dropbox/TUKAN"

# Or create symlink
ln -s ~/Dropbox/TUKAN ~/Documents/.TUKAN
```

---

### Note Templates

**Create templates directory:**
```bash
mkdir ~/Documents/.TUKAN/Templates/
```

**Meeting template:**
```markdown
# Meeting: [TOPIC]
#meeting #[project]

**Date**: DD/MM/YYYY
**Participants**: 
**Duration**: 

## Agenda
1. 
2. 
3. 

## Notes


## Actions
- [ ] 
- [ ] 

## Next Steps

```

**Task template:**
```markdown
# [TASK NAME]
#task #[project] #[priority]

## Description


## Requirements
- 
- 

## Steps
1. 
2. 
3. 

## Notes


## Status
- [ ] Started
- [ ] In progress
- [ ] Blocked
- [ ] Completed
```

---

### Custom Shortcuts

**Add aliases in ~/.bashrc:**
```bash
# Open TUKAN
alias tk="cd ~/tukan && ./tukan.sh"

# Quick new note
alias tkn="cd ~/tukan && ./tukan.sh new"

# Quick search
alias tks="cd ~/tukan && ./tukan.sh search"
```

---

### Integration with Other Tools

**Convert to HTML:**
```bash
# Using pandoc
pandoc note.md -o note.html
```

**Convert to PDF:**
```bash
# Using pandoc
pandoc note.md -o note.pdf

# Using mdpdf
mdpdf note.md
```

**View in browser:**
```bash
# Using grip (GitHub markdown preview)
grip note.md
```

---

### Regular Maintenance

**Weekly:**
- Review notes in "Ideas"
- Move completed tasks
- Clean "Trash"
- Update tags

**Monthly:**
- Archive finished projects
- Review statistics
- Complete backup
- Reorganize structure

---

### Productivity

**Pomodoro with TUKAN:**
```
1. 📖 Open → Select task
2. 🍅 25 min of work
3. ✏️ Update note with progress
4. ☕ 5 min break
5. Repeat
```

**Daily review:**
```
End of day:
📊 Statistics → Today
See what was done
Plan tomorrow
```

**Weekly review:**
```
Friday:
📊 Statistics → This week
Analyze productivity
Adjust goals
```

---

## 📞 Support and Contribution

### Report Bugs

If you find an error:
1. Check version: `./tukan.sh --test`
2. Describe the problem
3. Steps to reproduce
4. Error output

### Request Features

Suggestions welcome:
- New functionalities
- UX improvements
- Integrations
- Optimizations

---

## 📄 License and Credits

Both Fuzpad and TUKAN are licensed under **GPL-3.0**.

**Original Credits:** [JianZcar](https://github.com/JianZcar/)  
**Development and Extensions:** [Daniel Horacio Braga] and the invaluable help of ChatGpt and Calude.ai

TUKAN is free software licensed under **GNU General Public License v3.0**.

This project is based on/forked from [Fuzpad](https://github.com/JianZcar/FuzPad) by [JianZcar](https://github.com/JianZcar), also licensed under GPL-3.0.

### Permissions
✅ Commercial use  
✅ Modification  
✅ Distribution  
✅ Private use

### Conditions
⚠️ Disclose source code  
⚠️ Same license (GPL-3.0)  
⚠️ State changes

### Limitations
❌ No warranty  
❌ No liability

See [LICENSE](LICENSE) for full legal text.

---

## 🙏 Credits

### Based on Fuzpad
TUKAN is a modular extension of **[Fuzpad](https://github.com/JianZcar/FuzPad)** by [JianZcar](https://github.com/JianZcar).

### Main Changes
- ✨ Modular architecture (10 independent modules)  
- ✨ Kanban directory system  
- ✨ Advanced tag management  
- ✨ Statistics and analysis  
- ✨ Unified METADATA preview  
- ✨ Enhanced search (names and content)  
- ✨ External configuration system  
- ✨ Multiple color themes  
- ✨ File size display

### Developed by
Daniel Horacio Braga - 2025

### Technologies
- `bash` - Shell scripting  
- `fzf` - Fuzzy finder  
- `mdcat` - Markdown renderer  
- `bat` - Syntax highlighter  
- `bc` - Calculator

---

## 🤝 Contributions

Contributions are welcome. By contributing, you agree that your code will be licensed under GPL-3.0.

1. Fork the project
2. Create your branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add: amazing feature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📚 Additional Resources

### External Documentation

- **fzf**: https://github.com/junegunn/fzf
- **bat**: https://github.com/sharkdp/bat
- **mdcat**: https://github.com/swsnr/mdcat
- **Markdown**: https://www.markdownguide.org/

### Recommended Tutorials

- Bash scripting: https://www.gnu.org/software/bash/manual/
- Kanban methodology: https://kanbantool.com/kanban-guide
- GTD: https://gettingthingsdone.com/

---

**🦜 TUKAN - YOUR KANBAN**

*Simple and effective note and task management in terminal*

Version: 1.0 Modular  
Last update: December 2025
