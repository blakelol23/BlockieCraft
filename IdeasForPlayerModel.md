# Major Gameplay Systems Update

This task adds multiple major gameplay systems inspired by **Minecraft Java Edition mechanics**.

The goal is not perfect recreation but **very similar gameplay feel and behavior**.

All systems must be **modular and scalable**, because more mobs, structures, and recipes will be added later.

---

# 1. Passive Mob System

Add passive animals:

• Cow  
• Pig  
• Chicken  
• Sheep  

These mobs should spawn naturally in the world.

---

## Mob Behavior

Passive mobs should:

• Wander randomly  
• Occasionally stop and idle  
• Avoid walking off cliffs  
• Not attack the player  

Movement should be **slow and simple**.

Typical behavior loop:


Idle → Wander → Idle → Wander


Wander movement should pick a **random direction every few seconds**.

---

## Mob Interaction

The player can **punch animals**, but animals **cannot be killed for now**.

When the player attacks a mob:

1. Apply **knockback**
2. Make the mob **flash red briefly**
3. Play **hurt sound**
4. Push mob away from player

This is similar to Minecraft's hit feedback.

---

## Knockback

Knockback should push the mob slightly away from the player.

Example logic:


direction = normalize(mobPosition - playerPosition)

mobVelocity += direction * knockbackForce


Knockback should decay gradually.

---

## Damage Flash

When hit, the mob should flash red briefly.

Implementation idea:


mobMaterial.color = red
reset to original color after ~100ms


This replicates Minecraft's hit feedback.

---

# 2. Cave Generation

Add underground cave systems to terrain generation.

Caves should:

• generate below surface level  
• create open tunnels and caverns  
• cut through terrain naturally  

---

## Cave Algorithm Options

Use one of these procedural techniques:

Recommended approach:


3D Perlin Noise / Simplex Noise threshold carving


Steps:

1. Generate normal terrain
2. Sample 3D noise underground
3. If noise value passes threshold → remove block

This creates organic caves.

---

## Cave Depth Rules

Caves should generate mostly below:


Y < 50% of world height


But some caves can open near the surface.

---

# 3. Village Generation

Add villages that spawn randomly across the world.

Villages should contain:

• Houses  
• Farms  
• Roads  

---

## Village Placement

Village spawning rules:


rare structure
spawn in plains-like terrain
avoid water and cliffs


Village center point should be selected first.

---

## Village Structure Generation

Village generation should:

1. Pick a **center location**
2. Generate **roads outward**
3. Place buildings along roads

Roads should be simple block paths.

Buildings should be **predefined templates**.

Example templates:


small house
farm
well


Templates can be stored as **block layout arrays**.

---

# 4. Crafting System Overhaul

Rewrite the crafting system.

The current system requires **exact slot placement**, which is incorrect.

Minecraft crafting recognizes **patterns regardless of position**.

Example:


stick recipe
X
X


Works anywhere in the grid.

---

## Crafting Pattern Detection

Recipes should:

• detect patterns anywhere in grid
• ignore empty surrounding slots
• allow rotated placement within grid space

Example:


[ ][X][ ]
[ ][X][ ]


Should still craft sticks.

---

## Recipe Storage

Recipes should be stored in a structured format.

Example:


{
output: "stick",
pattern: [
["plank"],
["plank"]
]
}


The crafting system should compare **trimmed crafting grid vs recipe pattern**.

---

## Recipe Book Improvements

Recipe book should support:

• many more recipes
• category grouping
• search capability later

But for now focus on:


flexible crafting detection


---

# 5. Movement Physics Improvements

Player movement should feel closer to Minecraft.

---

## Movement Speed

Approximate Minecraft walking speed:


≈ 4.3 blocks per second


---

## Jump Physics

Minecraft jump velocity:


~0.42


---

## Gravity

Minecraft gravity per tick:


~0.08


Terminal velocity should cap falling speed.

---

## Air Control

Players should retain **some movement control while airborne**, but weaker than on ground.

---

# 6. XP Bar

Add an **XP bar above the hotbar**.

Features:

• fills left → right
• increases when XP gained
• resets when level increases

Display:


XP level number above bar


XP should eventually come from:

• mobs
• mining
• crafting

But for now focus on **UI implementation**.

---

# 7. HUD Improvements

Current health and hunger UI is too small.

Update:

• hearts larger
• hunger icons larger
• easier to read

The HUD should resemble Minecraft's layout:


[Hearts] [Hunger]
Hotbar
XP Bar


Spacing should be balanced.

---

# AUDIO SYSTEMS

Add multiple sound feedback systems.

Sound greatly improves game feel.

---

# 8. Block Footstep Sounds

Footstep sounds should vary by block type.

Examples:


grass
stone
wood
sand


Implementation:

When player walks:


detect block below player
play matching footstep sound


Footsteps should play every few steps.

---

# 9. Block Break / Place Sounds

Add sounds for:

• breaking blocks
• placing blocks

Sound should depend on block type.

Example:


stone break
wood break
dirt break


---

# 10. Rain Sound

When raining:

• loop rain sound
• volume increases when outside
• quieter indoors

---

# 11. Mob Sound Effects

Animals should have sound effects.

Examples:


cow moo
pig oink
chicken cluck
sheep baa


Sounds should play:

• randomly while idle
• when hurt

---

# 12. XP Pickup Sound

When collecting XP:


play XP chime


Classic Minecraft XP sound.

---

# 13. Item Pickup Sound

When picking up items:


play pickup sound


Short pop sound.

---

# 14. Player Hurt / Death Sounds

Player should have sound feedback when:

• taking damage
• dying

---

# Implementation Requirements

All systems must:

• be modular  
• avoid hardcoded logic  
• support future expansion  
• run efficiently  

Avoid building systems that only support these specific mobs or structures.

They should be extendable for:


more mobs
more structures
more recipes
more sounds


---

# Future Systems (Do Not Implement Yet)

These will be added later:


hostile mobs
trading villagers
cave ambient sounds
biome-specific villages
mob breeding


Focus only on the systems described above.