# Ability System Overhaul - Functional Spells

## Changes Made

### New Specialized Ability Scripts

Created individual scripts for each spell with unique behaviors:

1. **FireballAbility.gd** - Launches a fireball projectile towards mouse cursor
   - Damage: 25
   - Speed: 250
   - Creates fire trail particles

2. **IceSpikeAbility.gd** - Shoots ice spike projectile towards mouse cursor
   - Damage: 20
   - Speed: 300 (faster than fireball)
   - Creates ice trail particles

3. **BlinkAbility.gd** - Teleports player 100 units towards mouse cursor
   - Checks for walls using raycasting
   - Creates cyan particle effects at start and end positions
   - Smart collision detection prevents teleporting into walls

4. **ManaShieldAbility.gd** - Creates protective shield for 5 seconds
   - 50% damage reduction
   - Visual blue shield effect with pulsing animation
   - Automatically expires after duration

5. **DivineShieldAbility.gd** - Stronger protective shield for 4 seconds
   - 70% damage reduction
   - Visual golden shield effect with pulsing animation
   - Paladin's ultimate defensive ability

6. **LayOnHandsAbility.gd** - Instant healing
   - Heals 30 HP
   - Golden particle effect
   - Cannot overheal past max HP

7. **HolyStrikeAbility.gd** - Melee holy damage in direction of cursor
   - 15 bonus damage
   - 30 unit strike range
   - Hits all enemies in small area
   - Yellow particle effect at strike location

### New Projectile System

**SpellProjectile.gd** - Base script for spell projectiles
- Extends Projectile class
- `set_direction(Vector2)` method to fire towards cursor
- Automatic rotation to face direction

**Projectile Scenes:**
- `fireball_projectile.tscn` - Orange glowing orb with fire trail
- `ice_spike_projectile.tscn` - Blue capsule with ice trail

Both projectiles:
- Auto-destroy when hitting walls/enemies
- Auto-destroy when leaving screen
- Deal damage on contact
- Apply knockback force

### Enhanced Damage System

**Character.gd** - Updated `take_damage()` function
- Now checks for active shield buffs (DivineShield/ManaShield)
- Applies damage reduction based on shield type
- Prints debug info when shields absorb damage

### Direction Tracking

All spells now use `player.look_direction` which is automatically calculated based on:
- Player position
- Mouse cursor position
- Updated every frame in `Player._process()`

### Updated Resources

All 7 ability `.tres` files now reference their specialized scripts:
- Fireball.tres → FireballAbility.gd
- IceSpike.tres → IceSpikeAbility.gd
- Blink.tres → BlinkAbility.gd
- ManaShield.tres → ManaShieldAbility.gd
- DivineShield.tres → DivineShieldAbility.gd
- LayOnHands.tres → LayOnHandsAbility.gd
- HolyStrike.tres → HolyStrikeAbility.gd

## How It Works

1. **Player presses ability hotkey (1-5)**
2. **AbilityManager calls ability's `activate(player)` method**
3. **Ability checks `can_use()` (cooldown, etc.)**
4. **Ability performs its unique action:**
   - Projectiles: Instantiate and fire towards cursor
   - Blink: Calculate target position, raycast for walls, teleport
   - Shields: Create visual effect, add buff node to player
   - Healing: Call `player.heal()`, spawn particles
   - Holy Strike: Raycast for enemies, deal damage in area
5. **Visual feedback spawned (particles, effects)**
6. **Cooldown starts in AbilityManager**

## Testing

To test each ability:
1. Select **Wizard** class (has Fireball, IceSpike, Blink, ManaShield)
2. Press **1-4** to use abilities
3. Aim with mouse cursor
4. Select **Paladin** class (has HolyStrike, DivineShield, LayOnHands)
5. Press **1-3** to use abilities

### Expected Behaviors:
- ✅ Fireball/IceSpike fly towards cursor and damage enemies
- ✅ Blink teleports you towards cursor (max 100 units)
- ✅ Shields show visual effect and reduce incoming damage
- ✅ Lay on Hands heals you with golden particles
- ✅ Holy Strike damages enemies near cursor position

## Future Improvements

- Add mana cost enforcement (currently abilities are free)
- Create Warrior and Ranger abilities
- Add status effect indicators (buff icons)
- Implement ability upgrade system
- Add combo system for chaining abilities
- Particle effect improvements
- Sound effects for each ability
