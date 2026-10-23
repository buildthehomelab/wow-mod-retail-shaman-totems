# mod-retail-shaman-totems

Totem looks for the shamans of a 3.3.5a realm: 80 looks in 20 sets of four (fire, earth, water, air),
picked per element in the Totems tab of the Transmogrify window, whatever the shaman's race.

It is a look pack for [wow-mod-transmog-plus](https://github.com/buildthehomelab/wow-mod-transmog-plus),
which has the tab, remembers what each character picked and swaps the model. A pack is two things:

- a small server module: its world SQL lists the looks (`data/sql/db-world/mod_retail_shaman_totems.sql`). There
  is no code to run and nothing to configure.
- a client patch with the models (`patch-V.MPQ` in the examples below; any free letter works).
  Everyone with the patch sees everyone's looks, with no client hacks.

Both are built from this repo's list of looks with
[wow-mod-retail-creatures](https://github.com/buildthehomelab/wow-mod-retail-creatures), the
converter the packs share.

## The totems

`data/totems.tsv` lists 80 totem looks: 20 sets of four (fire, earth, water, air). A shaman
picks a look per element, whatever their race.

Five sets are the 3.3.5a client's own race totems. They need no patch and keep all their
effects; any shaman can use them from the start. The other 15 are retail's, converted:

| Phase | Unlocks |
| --- | --- |
| 0 | Tauren, Orc, Troll, Dwarf and Draenei totems (the client's own) |
| 1 Molten Core | Dark Iron |
| 2 Onyxia | Tauren (Remastered), retail's remake of the classic totems |
| 3 Blackwing Lair | Goblin |
| 4 Zul'Gurub | Zandalari |
| 5 AQ War Effort | Vulpera |
| 6 Ahn'Qiraj | Pandaren |
| 7 Naxxramas | Dark Shaman (Ashflare, Rusted Iron, Foulstream, Poisonmist) |
| 8 Road to Outland | Highmountain |
| 9 Karazhan / Gruul / Magtheridon | Mag'har |
| 10 SSC / Tempest Keep | Kul Tiran |
| 11 Hyjal / Black Temple | Draenor Clans |
| 12 Zul'Aman | Haranir |
| 13 Sunwell | Draenei (Remastered), retail's crystal totems |
| 15 Ulduar | Earthen |
| 17 Icecrown Citadel | Maelstrom (the Legion class hall totems) |

Retail has no table of totem looks (a totem follows the shaman's race), so the sets, their
retail display ids and their phases are listed in `tools/inventory.py`. To move a set,
change its phase there and rerun it.

## Installing

1. Install [wow-mod-transmog-plus](https://github.com/buildthehomelab/wow-mod-transmog-plus).
2. Add this module and rebuild. The SQL applies on the next start, and the shamans' Totems tab appears.

   ```bash
   cd azerothcore/modules
   git clone https://github.com/buildthehomelab/wow-mod-retail-shaman-totems.git mod-retail-shaman-totems
   ```

   Clone into `mod-retail-shaman-totems` exactly: AzerothCore derives the module's loader function from the folder
   name.
3. Build the client patch (below) and give it to every player. It has to be required: a player
   without it sees nothing where one of these looks stands.

Without this module the realm is plain transmog: no looks, no tab.

## Building the client patch

Clone the converter next to this repo (as `mod-retail-creatures`), or point `RETAIL_CREATURES` at it.

```bash
python3 tools/inventory.py --cache ~/retail-cache
```

```bash
python3 ../mod-retail-creatures/tools/build_patch.py --pack . --dbc <dbc dir> --cache ~/retail-cache --work ~/mod_retail_shaman_totems-work --out patch-V.MPQ --sql data/sql/db-world/mod_retail_shaman_totems.sql
```

`inventory.py` writes `data/totems.tsv` from the sets listed in it. Display ids already in the
file never move. Run it only after adding a set or moving one to another phase.

`--dbc` needs `CreatureDisplayInfo.dbc`, `CreatureModelData.dbc` and `AnimationData.dbc` as the
players' client has them. A patch replaces whole files, and another pack's patch ships the same two
creature DBCs: on a realm that also has the druid forms (`patch-R.MPQ` in that pack's examples),
build this one with `--dbc` holding the two DBCs from the finished patch-R (plus the stock `AnimationData.dbc`), and rebuild it
whenever patch-R changes. The later letter wins, so this patch needs a later letter than the
druid forms patch and carries its rows.

The build rewrites `data/sql/db-world/mod_retail_shaman_totems.sql` to match the patch: commit it with the
patch you ship. Ids: CreatureDisplayInfo 96000+ (the five stock sets keep the client's own ids), CreatureModelData 96000+, preview creatures in
9501500-9501999 (subname `Totem`), `pack.json` has them all.

Nothing from Blizzard is stored in this repo; the files come from wago.tools at build time.

## Uninstalling

Remove the module folder, rebuild, and run `data/sql/uninstall/mod_retail_shaman_totems_uninstall.sql` by hand.
Players can keep the patch: unused displays do nothing.

## Requirements

- AzerothCore with [wow-mod-transmog-plus](https://github.com/buildthehomelab/wow-mod-transmog-plus).
- To build the patch: [wow-mod-retail-creatures](https://github.com/buildthehomelab/wow-mod-retail-creatures)
  and what it needs (Python 3.10+, StormLib).

## Troubleshooting

- **Druid forms vanish after adding patch-V**: it was built on DBCs without the form rows. Build
  it with `--dbc` from patch-R.
- **A retail totem has no flames, drips or sparks**: the patch was built without the pack's
  `"effects": true`, or by a converter older than its particle support. Rebuild it with a current
  `wow-mod-retail-creatures`.
- Anything about the models themselves (black or tiny previews, missing effects, white armour
  on other creatures): see the converter's
  [troubleshooting](https://github.com/buildthehomelab/wow-mod-retail-creatures#troubleshooting).

## Credits

- Model and table data: Blizzard Entertainment, downloaded at build time from
  [wago.tools](https://wago.tools); file names from the
  [wowdev community listfile](https://github.com/wowdev/wow-listfile).
- M2 format notes: [wowdev.wiki](https://wowdev.wiki/M2) and
  [whoa](https://github.com/thunderbrewhq/whoa).

## Patch Notes: Shaman Totem Looks

Category: Classes / Shaman

- Shamans can now choose a look for each totem element, from the new Totems tab of the
  Transmogrify window (`/transmog`).
- The Tauren, Orc, Troll, Dwarf and Draenei totems are open to every shaman from the start,
  whatever their race.
- Every raid tier you clear unlocks a retail set, from the Dark Iron totems in Molten Core to
  the Maelstrom totems in Icecrown Citadel.

- The retail totems now have their flames, drips, sparks and swirling wind trails.

## License

MIT. See [LICENSE](LICENSE).
