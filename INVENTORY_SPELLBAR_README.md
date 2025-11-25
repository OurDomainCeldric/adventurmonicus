# Spell Bar & Advanced Inventory System

## Overview
A complete spell bar and inventory system with hotkeys, drag-and-drop, equipment slots, and ability management.

## Features Implemented

### 1. Spell Bar (Bottom of Screen)
- **5 ability slots** with visual cooldown indicators
- **Hotkeys: 1-5** to activate abilities
- **Visual feedback** when abilities come off cooldown
- **Cooldown overlay** shows remaining time
- Automatically populated from player class

### 2. Full Inventory System
- **Toggle with 'I' key** to open/close
- **Drag-and-drop** items between slots
- **Grid-based layout** for items
- **Item tooltips** on hover with name and description
- **Pause game** when inventory is open

### 3. Equipment System
- **Weapon slot** - drag weapons to equip
- **Shield slot** - drag shields to equip
- **Drag equipment** back to inventory to unequip
- **Swap items** between equipment slots
- **Visual indicators** for equipped items

### 4. Ability System
- **AbilityData** resource for defining abilities
- **AbilityManager** handles cooldowns and activation
- **Extensible** for adding custom ability logic
- Each class can have unique abilities

## New Files Created

### Core Scripts
- `Scripts/Abilities/AbilityData.gd` - Base ability resource
- `Scripts/Abilities/AbilityManager.gd` - Manages ability cooldowns and usage
- `Scripts/UI/SpellBarUI.gd` - Spell bar controller
- `Scripts/UI/SpellBarSlot.gd` - Individual spell slot
- `Scripts/UI/FullInventoryUI.gd` - Full inventory UI controller
- `Scripts/UI/EquipmentSlotUI.gd` - Equipment slot with drag-drop
- `Scripts/UI/DraggableItem.gd` - Drag-and-drop helper
- `Scripts/UI/PlayerHUD.gd` - Main HUD controller

### Scene Files
- `Scenes/UI/player_hud.tscn` - Complete player HUD
- `Scenes/UI/spell_bar_slot.tscn` - Spell bar slot template
- `Scenes/UI/equipment_slot.tscn` - Equipment slot template

### Resources
- `Items/Abilities/HolyStrike.tres` - Example ability

## Input Mapping (Added to project.godot)

| Key | Action | Description |
|-----|--------|-------------|
| I | `toggle_inventory` | Open/close inventory |
| 1 | `ability_1` | Use ability slot 1 |
| 2 | `ability_2` | Use ability slot 2 |
| 3 | `ability_3` | Use ability slot 3 |
| 4 | `ability_4` | Use ability slot 4 |
| 5 | `ability_5` | Use ability slot 5 |

## How to Use

### Setting Up the HUD
1. Add `PlayerHUD.tscn` as a child of your Player node
2. The HUD will automatically initialize when the game starts
3. Abilities are loaded from the selected PlayerClass

### Creating New Abilities
1. Create a new Resource in `Items/Abilities/`
2. Set script to `AbilityData`
3. Configure properties:
   - `ability_name` - Display name
   - `description` - What it does
   - `icon` - Visual representation
   - `cooldown` - Seconds between uses
   - `mana_cost` - Resource cost (if implementing mana)
   - `ability_type` - INSTANT, PROJECTILE, AREA, BUFF, or SUMMON

4. Add to PlayerClass:
```gdscript
# In PlayerClass.tres
abilities = [
    preload("res://Items/Abilities/HolyStrike.tres"),
    preload("res://Items/Abilities/DivineShield.tres"),
    # ... up to 5 abilities
]
```

### Implementing Ability Logic
Extend `AbilityData` for custom abilities:

```gdscript
# Scripts/Abilities/HolyStrikeAbility.gd
extends AbilityData

func activate(player: Player) -> bool:
    if not can_use(player):
        return false
    
    # Your ability logic here
    print("Holy Strike activated!")
    
    # Deal bonus damage
    if player.weapons.current_weapon:
        # Apply holy damage effect
        pass
    
    return true

func can_use(player: Player) -> bool:
    # Custom validation
    return player.weapons.current_weapon != null
```

### Drag-and-Drop Usage
- **Inventory to Equipment**: Drag item to appropriate equipment slot
- **Equipment to Inventory**: Drag equipped item back to inventory
- **Swap Items**: Drag one item onto another to swap positions
- **Same-Type Stacking**: Compatible items stack automatically

## Modified Files

### Scripts/Character/Player.gd
- Added `@onready var ability_manager: AbilityManager`
- Added `_unhandled_input()` for ability hotkeys
- Added `_use_ability(index: int)` function
- Updated `_apply_selected_class()` to load abilities

### Scripts/Character/PlayerClass.gd
- Added `ability_descriptions: Array[String]` for display text
- Added `abilities: Array[AbilityData]` for actual usable abilities

### Scripts/UI/InventorySlotUI.gd
- Added `slot_index: int` property
- Added `_get_drag_data()` for drag support
- Added `_can_drop_data()` for drop validation
- Added `_drop_data()` for handling drops
- Added `_swap_slots()` helper function

### project.godot
- Added 6 new input actions (toggle_inventory, ability_1-5)

## Integration with Existing Systems

### Inventory System
- Works with existing `Inventory` class
- Uses existing `ItemSlot` structure
- Compatible with `ItemData`, `WeaponItemData`, `ShieldItemData`
- Maintains backward compatibility with old inventory UI

### Weapon System
- Integrates with `CharacterWeapons` class
- Equipment slots properly equip/unequip weapons
- Updates weapon visual representation
- Maintains shield blocking mechanics

## UI Architecture

```
PlayerHUD (CanvasLayer)
├── SpellBar (HBoxContainer)
│   ├── SpellBarSlot (Panel) x5
│   │   ├── Icon (TextureRect)
│   │   ├── CooldownOverlay (ColorRect)
│   │   ├── CooldownText (Label)
│   │   └── HotkeyLabel (Label)
├── FullInventory (Control) [Hidden by default]
    ├── DarkBackground (ColorRect)
    ├── MainPanel (Panel)
    │   ├── InventoryGrid (GridContainer)
    │   │   └── InventorySlotUI x[inventory.size]
    │   └── Equipment Slots
    │       ├── WeaponSlot (EquipmentSlotUI)
    │       └── ShieldSlot (EquipmentSlotUI)
    └── InfoPanel (Panel) [Shows on hover]
```

## Future Enhancements (Not Yet Implemented)

### Ability System Extensions
- **Mana/Energy System**: Add resource costs for abilities
- **Ability Upgrades**: Level up abilities for increased power
- **Ability Trees**: Unlock new abilities as you progress
- **Combo System**: Chain abilities for bonus effects
- **Status Effects**: Buffs/debuffs from abilities

### Inventory Improvements
- **Item Sorting**: Auto-sort by type, rarity, etc.
- **Quick-Use Slots**: Hotbar for consumables
- **Item Filtering**: Search and filter items
- **Bulk Actions**: Move/delete multiple items
- **Item Comparison**: Compare equipment stats

### Equipment Expansion
- **Armor Slots**: Helmet, Chest, Legs, Boots
- **Accessory Slots**: Rings, Amulets
- **Weapon Sets**: Quick-swap between weapon configurations
- **Stat Display**: Show equipment stats and bonuses
- **Set Bonuses**: Bonuses for wearing matching equipment

## Troubleshooting

### Inventory doesn't open with 'I'
- Check that `toggle_inventory` action is defined in project settings
- Ensure `FullInventoryUI` has `process_mode` set to handle input
- Verify the HUD is added as a child of the Player

### Abilities don't activate
- Ensure `AbilityManager` node exists as child of Player
- Check that PlayerClass has abilities assigned
- Verify ability hotkey actions in project settings
- Check if abilities are on cooldown

### Drag-and-drop not working
- Ensure UI elements have proper mouse filter settings
- Check that `_get_drag_data()` and `_drop_data()` are implemented
- Verify Control nodes have the script attached

### Items not equipping
- Check that item types match slot types (WeaponItemData → Weapon Slot)
- Ensure `CharacterWeapons` node exists on Player
- Verify equipment slot setup is called

## Performance Notes

- Inventory UI only updates when inventory changes (signal-based)
- Cooldown visuals update every frame but are lightweight
- Drag preview is destroyed after drop
- Inventory pauses game to prevent combat while managing items

## Testing Checklist

- [ ] Open/close inventory with 'I'
- [ ] Drag items between inventory slots
- [ ] Equip weapon by dragging to weapon slot
- [ ] Equip shield by dragging to shield slot
- [ ] Unequip items back to inventory
- [ ] Press 1-5 to use abilities
- [ ] Abilities show cooldown properly
- [ ] Hover over items shows tooltip
- [ ] Game pauses when inventory open
- [ ] Class selection loads correct abilities
