# Class Selection System

## Overview
The game now includes a class selection system at startup where players can choose from 4 classes: Paladin, Wizard, Warrior, and Ranger.

## Files Created

### Core Scripts
- **Scripts/Character/PlayerClass.gd** - Resource script defining class properties (stats, weapons, abilities)
- **Scripts/AutoLoads/game_state.gd** - Autoload singleton to store selected class across scenes
- **Scripts/UI/class_selection.gd** - UI controller for class selection screen
- **Scripts/Character/PlayerClassTester.gd** - Helper script for testing with default classes

### Resources (Class Data)
- **Items/Classes/Paladin.tres** - Paladin class (Sword + Shield, balanced, healing)
- **Items/Classes/Wizard.tres** - Wizard class (No weapon, magic abilities, fragile)
- **Items/Classes/Warrior.tres** - Warrior class (Axe, high HP, melee)
- **Items/Classes/Ranger.tres** - Ranger class (Bow, high speed, ranged)

### Scenes
- **Scenes/UI/class_selection.tscn** - Class selection UI screen

## Class Characteristics

### Paladin
- **HP:** 12/12
- **Speed:** 18
- **Weight:** 1.2
- **Weapons:** Sword + Shield
- **Abilities:** Holy Strike, Divine Shield, Lay on Hands

### Wizard
- **HP:** 8/8
- **Speed:** 22
- **Weight:** 0.8
- **Weapons:** None (magic-based)
- **Abilities:** Fireball, Ice Spike, Blink, Mana Shield

### Warrior
- **HP:** 15/15
- **Speed:** 16
- **Weight:** 1.5
- **Weapons:** Axe
- **Abilities:** Berserker Rage, Cleave, War Cry, Second Wind

### Ranger
- **HP:** 10/10
- **Speed:** 24
- **Weight:** 0.9
- **Weapons:** Bow
- **Abilities:** Multi-Shot, Trap, Evasion, Hunter's Mark

## How It Works

1. **Game Start:** Players see the class selection screen (now the main scene)
2. **Selection:** Click a class button to select it, hover to preview stats
3. **Confirmation:** Click "CONFIRM SELECTION" to start the game
4. **Game Start:** The main game scene loads with selected class applied to player

## Modified Files

### project.godot
- Added `GameState` autoload
- Changed main scene to `res://Scenes/UI/class_selection.tscn`

### Scripts/Character/Player.gd
- Added `_ready()` function
- Added `_apply_selected_class()` to load class stats and equipment

## Testing

To test without going through class selection each time:
1. Add a `PlayerClassTester` node to your test scene
2. Assign a `default_test_class` in the inspector
3. The tester will auto-select that class if none is chosen

## Customization

### Adding New Classes
1. Create a new `.tres` file in `Items/Classes/`
2. Set script to `PlayerClass`
3. Configure stats, weapons, and abilities
4. Add button to `class_selection.tscn`
5. Connect button in `class_selection.gd`

### Modifying Existing Classes
Edit the `.tres` files in `Items/Classes/` to adjust:
- Starting stats (HP, speed, weight)
- Starting weapons/shields
- Additional starting items
- Ability descriptions

## Future Enhancements (Not Yet Implemented)

The ability strings are currently descriptive text. To make abilities functional, you would need to:
1. Create an ability system (scripts for each ability)
2. Add ability activation logic to Player.gd
3. Create UI for ability hotkeys
4. Implement cooldowns and resource costs (mana, stamina, etc.)
