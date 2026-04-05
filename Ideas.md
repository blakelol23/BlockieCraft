# BlockieCraft Feature Audit and Roadmap

This file compares BlockieCraft to core Minecraft survival mechanics and maps gaps to a practical build order.

## What You Already Have (Strong Foundation)

- Procedural chunked world generation with caves, rivers, and biome selection.
- Day/night cycle, sun/moon, stars, clouds, and dynamic rain with ambient audio fading.
- Survival HUD and systems: health, hunger, saturation, drowning, starvation, regen, fall damage.
- Inventory, hotbar, 2x2 crafting, 3x3 crafting table, chest UI and chest storage (runtime).
- Tool durability, block hardness, break speed differences by tool type.
- Block drops, item pickups, particle effects, and water spreading simulation.
- Basic passive mobs (cow/pig/sheep/chicken) with spawning, wandering, and despawn.
- Chat command system (/give, /spawn, /tp, /time, /heal, /kill, /seed, /gamemode, /xp).
- XP bar and leveling logic.

## Major Missing Mechanics (Compared To Minecraft Survival)

### Progression blockers

- No ore and metal progression loop yet (coal, iron, gold, diamond, etc.).
- No furnace/smelting system (input/fuel/output, timers, XP from smelting).
- No hostile mob gameplay loop (night threat, combat pressure, base defense).
- No armor/weapons progression loop despite attack indicator and armor UI slots.

### World progression blockers

- No Nether portal/dimension loop.
- No End/stronghold/dragon loop.
- No boss progression (Wither/Dragon equivalents) or game completion milestones.

### System depth blockers

- No mob health/death/loot table pipeline for mobs (they can be punched/knocked back, but not killed for drops).
- No persistent world save/load (localStorage is currently settings-focused; world/chunks/inventory are not persisted between sessions).
- No villager/trading economy loop.
- No farming/crop lifecycle loop (farmland, growth stages, harvesting, replanting).
- No brewing, potion, enchanting, anvil, or status-effect ecosystem.
- No redstone/power/automation layer.

## High Priority Improvements To Existing Systems

- Combat feedback and balancing:
	- Add mob/player damage model with attack values, invulnerability frames, and death handling.
	- Add weapon classes and make attack cooldown meaningful.
- Inventory/crafting quality:
	- Add recipe discovery/recipe book and clearer crafting feedback.
	- Add stack split/merge UX polish and shift-click transfer behavior consistency.
- World interaction:
	- Improve water bucket behavior (source consume/return semantics) and edge cases.
	- Add stronger block interaction rules (tool requirements, drops by tool tier).
- Worldgen content variety:
	- Add ore distributions by depth and biome.
	- Expand generated structures beyond simple village shells.

## Recommended Build Order (Practical Roadmap)

## Phase 1: Core Survival Completion

- Add entity health/death/drop pipeline (for all mobs and later hostile mobs).
- Add ore blocks and ore generation by Y-level.
- Add furnace block + furnace UI + smelting recipes + fuel system.
- Add basic hostile mobs (zombie/skeleton/spider equivalent) with nighttime spawn rules.
- Add simple combat items (sword, armor) and armor protection calculations.

Success criteria:
- Player can mine ore, smelt it, craft better gear, survive nightly threats.

## Phase 2: Midgame Loops

- Add farming (seeds, farmland hydration, growth stages, harvest).
- Add animal breeding and food/ecosystem loops.
- Add villager entities + basic trading.
- Add enchanting table + basic enchant pool (Efficiency, Unbreaking, Sharpness).

Success criteria:
- Player can sustain resources and optimize gear instead of only exploring/mining.

## Phase 3: World Progression

- Add Nether portal and Nether dimension generation pass.
- Add Nether-exclusive resources required for End progression.
- Add stronghold/End portal flow and End dimension entry.
- Add dragon boss fight and post-win rewards.

Success criteria:
- Full beginning-to-end survival arc exists.

## Phase 4: Sandbox Depth

- Add redstone-style logic (start minimal: lever, wire, torch inverter, piston).
- Add automation hooks (hopper-like item transfer, auto-smelting eventually).
- Add advancements/objectives/challenges.

Success criteria:
- Replayability and creative engineering depth become a core reason to keep playing.

## Technical Tasks Needed Early (Before Features Scale)

- Implement a save format and versioning:
	- World seed and time.
	- Modified blocks/fluids.
	- Player state (position, inventory, stats, XP, gamemode).
	- Mob state and chest contents.
- Separate data and behavior more cleanly:
	- Entity component schema (health, ai, drops, faction).
	- Recipe registry and loot table registry.
	- Biome/block/item IDs in centralized registries.
- Add debug toggles for balancing:
	- Spawn rates, mob damage, hunger drain, smelt speed, ore rates.

## Suggested Next 5 Concrete Tasks

- 1. Add `health`, `maxHealth`, `drops`, and `onDeath` to mob entities; allow killing mobs.
- 2. Add `COAL_ORE`, `IRON_ORE`, `RAW_IRON`, `IRON_INGOT` and depth-based ore generation.
- 3. Add a furnace block + UI with input/fuel/output and tick-based smelting.
- 4. Add one hostile mob with simple chase/attack AI and nighttime spawning.
- 5. Add world save/load in localStorage for player state + modified blocks + inventory.

If we follow this order, the game quickly shifts from "tech demo with strong base systems" into a full survival loop.

