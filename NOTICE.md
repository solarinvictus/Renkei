# Source and license

Renkei is a modified version of Chains-Horizon:
https://github.com/NerfOnline/Chains-Horizon

Source revision: e72898a5afe9029e428116525a33e16d470faa4a
Retrieved and modified: 2026-10-13

Original skillchain implementation: Ivaar.
Ashita v4 port: Sippius.
Horizon enhancements: NerfOnline.
Referenced engine contributors include Thorny and The Mystic.

Renkei modifications: new FFXI-inspired renderer and settings theme; independent
addon/command namespace; fractional ImGui time; readable element palette;
realistic sample chain; zone/character cleanup; defensive packet checks;
bounded scale input; command settings persistence.

The addon and new UI are distributed under GPL-3.0-or-later. The full GPL v3
license is in LICENSE. All Lua source necessary to run this version is included.
The skills data retains Ivaar's original BSD-style notice in skills.lua.
Horizon skills.lua was rendered from upstream scripts/skills-data-horizon.lua
using upstream's render_skills function. pets.lua is unchanged upstream code.

No endorsement by upstream authors, HorizonXI, Ashita or Square Enix is implied.

2026-10-15: fixed scale-down width retention by measuring in the panel font context and explicitly sizing its width.
