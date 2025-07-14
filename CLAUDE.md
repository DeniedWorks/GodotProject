# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
- **Game Type:** 3D Online Action RPG
- **Target Platform:** PC
- **Art Style:** 3D Stylized potentially cell shading.
- **Core Mechanics:** Killing monsters, Completing quests, Gathering and Crafting, Realtime Combat
- **Current Stage:** Prototype
I want the language used to be GDScript. Only use other languages if neccessary.
My end goal is to create an MMORPG. Right now I am trying trying to create the player movement and combat with some basic AI to kill.

## Key Development Commands
- `godot --headless --export-release "Windows Desktop" builds/game.exe` - Build for Windows
- `git add . && git commit -m "message"` - Quick commit
- Common scene paths and script locations

### Building the Project
```bash
# Build the C# project
dotnet build

# Build in Release mode
dotnet build -c Release

# Clean and rebuild
dotnet clean
dotnet build
```

### Running the Game
```bash
# Run from Godot editor (recommended)
godot

# Run directly from command line
godot --path . 

# Run specific scene
godot --path . res://demo.tscn
```

### Linting and Code Quality
```bash
# Format C# code
dotnet format

# Check C# code issues
dotnet build -warnaserror
```

## Project Architecture

### Directory Structure
- **`Demo/`**: Complete demo implementation with terrain, player mechanics, and UI
  - `src/`: GDScript files for gameplay logic (Player.gd, Enemy.gd, CameraManager.gd, etc.)
  - `components/`: Scene files for game objects
  - `assets/`: 3D models, materials, and textures
- **`addons/`**: Terrain editing plugin
  - `terrain_3d/`: C++ GDExtension for terrain (enabled in project)
- **`Polygon/`**: Modular character system with multiple texture variations
- **`Textures/`**: Terrain textures (grass, ground, moss)

### Key Configuration
- **Engine**: Godot 4.4 with C# support
- **Main Scene**: `demo.tscn` (uid://djohvfhlk6cr7)
- **Input Mapping**: WASD for movement, Space for jump
- **Build Configurations**: Debug, ExportDebug, ExportRelease

### Important Scripts
- `player.gd`: Main player controller at root level
- `Demo/src/Player.gd`: Demo-specific player implementation
- `Demo/src/CameraManager.gd`: Camera control system
- `Demo/src/RuntimeNavigationBaker.gd`: Dynamic navigation mesh generation

### Shader System
- Global shader parameters configured for wind effects and player position tracking
- Multiple custom shaders for terrain, water, and visual effects
- Shader includes (`.gdshaderinc`) for code reuse

## Development Workflow

### Adding New Features
1. Check existing implementations in `Demo/src/` for patterns
2. Follow GDScript style conventions from existing files
3. Use the established component structure in `Demo/components/`

### Working with Terrain
- Terrain3D plugin is the primary terrain system (enabled in project settings)
- Terrain data stored in `Terrain3D/` and demo-specific data in `Demo/data/`
- Navigation meshes can be baked at runtime using `RuntimeNavigationBaker.gd`

### C# Development
- Target framework: .NET 8.0
- Root namespace: `NewGameProject`
- Solution includes three build configurations for different scenarios

### Testing
No test framework is currently configured. Consider adding GdUnit4 for unit testing.

### Exporting
Export presets not yet configured. Use Godot editor to set up export templates for target platforms.