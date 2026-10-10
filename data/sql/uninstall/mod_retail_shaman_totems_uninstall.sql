-- Removes this pack's looks. Run by hand (the server never applies data/sql/uninstall), on
-- acore_world and acore_characters as marked. Players can keep patch-V: unused displays do nothing.

-- acore_world
DELETE FROM `mod_transmog_plus_forms` WHERE `Form` IN ('fire', 'earth', 'water', 'air');
DELETE m FROM `creature_template_model` m JOIN `creature_template` t ON t.`entry` = m.`CreatureID`
WHERE t.`entry` BETWEEN 9501500 AND 9501999 AND t.`subname` = 'Totem';
DELETE t FROM `creature_template` t WHERE t.`entry` BETWEEN 9501500 AND 9501999 AND t.`subname` = 'Totem';
DELETE FROM `creature_model_info` WHERE `DisplayID` BETWEEN 96000 AND 96999;
DELETE FROM `creaturedisplayinfo_dbc` WHERE `ID` BETWEEN 96000 AND 96999;
DELETE FROM `creaturemodeldata_dbc` WHERE `ID` BETWEEN 96000 AND 96999;

-- acore_characters: the looks characters picked from this pack
-- DELETE FROM `mod_transmog_plus_form_choice` WHERE `Form` BETWEEN 7 AND 10;
