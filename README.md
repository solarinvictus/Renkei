# Renkei — FFXI Skillchain Navigator

Version 1.0.7 • Ashita v4 • HorizonXI

A standalone, FFXI-inspired blue-and-silver skillchain panel. Based on the
Chains-Horizon combat engine, with an original native ImGui interface.

Fixed in 1.0.1: panel width shrinks correctly when scale is reduced, including both supported ImGui font APIs.

Changed in 1.0.2: compact 300px panel at scale 1.0. Long action/result pairs and informational text wrap instead of widening the window. Width follows the scale setting.

Changed in 1.0.3: enforce a 280px width at normal scale before the panel opens, with equal minimum and maximum width bounds to prevent auto-fit from retaining its previous width.

Changed in 1.0.4: slightly wider 320px panel at normal scale, retaining enforced width bounds.

Changed in 1.0.5: 0.18-second center-out opening and closing animations with fading. Chain advances stay open; ending or leaving a chain plays the closing animation.

Changed in 1.0.6: reference-inspired 0.28-second two-axis box zoom with a translucent leading frame. Text appears near the end of opening and disappears first on closing.

Changed in 1.0.7: restored the original v1.0.4 background, outer border, and frame when fully open; retained the two-axis opening/closing animation.

## Install

1. Extract the `renkei` folder into the `addons` directory used by your Horizon
   Ashita installation. The resulting path must be `addons/renkei/renkei.lua`,
   with `skills.lua`, `pets.lua`, and `theme.lua` alongside it.
2. In game, enter `/addon load renkei`.
3. Enter `/renkei` to open settings and the sample preview. Drag the preview
   window to position it. Enter `/renkei` again to close settings and lock it.
4. To load automatically, add `/addon load renkei` to your active Ashita startup
   script, alongside your other addon load commands.

No extra plugin, texture download, or font installation is needed. This is not
a Windower addon. If you already use Chains or Skillchains, unload that addon
if you do not want two panels. Renkei has its own folder, command and settings.

## During combat

- Target the monster receiving your party/alliance's skillchain actions.
- An opening weapon skill displays its properties and a **WAIT** countdown.
- **CHAIN WINDOW** shows estimated time remaining for the next action to land.
- Follow-ups show the action and resulting skillchain, grouped by weapon skills,
  spells and pets, with higher-level results first.
- After a skillchain, **BURST ELEMENTS** lists compatible elements. This is not
  a separate, authoritative magic-burst timer.
- A terminal chain displays **CHAIN COMPLETE** with no further suggestions.
- The panel hides when the tracked window expires. `/renkei` always provides a
  looping preview outside combat. Preview actions are examples, not your loadout.

Weapon skills come from the client's available weapon-skill list. The included
skill data is the upstream **Horizon** variant, not its default retail database.
BLU spell and pet recommendations are inherited from that engine; spell ability
requirements are enabled by default. Dimmed entries lack a tracked prerequisite.
Recommendations do not guarantee sufficient TP, MP, range, recast or resources.

Timings are estimates from received action packets and per-action delays. Act
early enough for your weapon skill or spell to land before the window closes.
The addon only observes combat and draws a UI; it does not execute actions.

## Commands

| Command | Effect |
|---|---|
| `/renkei` | Toggle settings and preview; unlock dragging while open |
| `/renkei scale 1.2` | Scale text/UI, from 0.5 to 3.0 |
| `/renkei move 100 200` | Move to screen coordinates |
| `/renkei reset` | Return the panel to the upper-left corner |
| `/renkei direction` | Toggle top/bottom anchoring as the panel changes height |
| `/renkei color` | Toggle skillchain/element colors |
| `/renkei weapon` | Toggle weapon-skill suggestions |
| `/renkei spell` | Toggle spell suggestions |
| `/renkei pet` | Toggle pet suggestions |
| `/renkei ability` | Require the tracked spell-chain ability for suggestions |
| `/renkei smn` | Require the matching summoned avatar |
| `/renkei pup` | Require the matching automaton frame |
| `/renkei help` | Show additional commands supported by the dataset |
| `/addon unload renkei` | Unload the addon |

Preferences are saved by Ashita's settings library. To customize the visual
palette, edit `theme.lua`; element colors are in `renkei.lua`.

## Validation and limits

All four Lua files passed LuaJIT 5.1 syntax checks. An offline mocked-Ashita
replay exercised the actual packet parser and renderer with opening weapon
skills, confirmed skillchains, timers, target changes, expiry, misses,
non-alliance actors, terminal chains, zoning, truncated packets, settings and
preview. Style/font stacks were checked for balance.

**Not yet tested in a live FFXI/Ashita client.** The offline checks cannot verify
your installed Ashita build, actual screen rendering, or all Horizon-specific
BLU/pet behavior. If an error occurs, send the complete error text and the action
that triggered it. Upstream tracking primarily handles the first action/target
in each packet; simultaneous multi-target actions can be incomplete.

The UI recreates the visual character of the classic menus using native shapes
and your Ashita font. It does not include Square Enix textures or its damage font.

See `NOTICE.md` and `LICENSE` for source and licensing.
