# Procedure

Here we list some rules we used in processing the data

## Updating scientific names

We keep the original scientific name in `verbatimScientificName` to be able to link back to the original dataset when no taxonID is available and to easily see which names are updated.

We update names to correct typographic issues:

* Remove typos to avoid misses in strict mode: `AseroÙ rubra` → `Asero rubra`
* Remove double and trailing spaces: `Aethusa cynapium  agrestis` → `Aethusa cynapium agrestis`
* Remove `sp.`, `spp.`, `spec.` indications: `Parthenocissus spp.` → `Parthenocissus`
* Remove double quotes: `Procambarus "(""Marmorkrebs"")"` → `Procambarus "(""Marmorkrebs"")"`
* Remove the hybrid combination for named hybrids: `Amaranthus x ralletii Contré (A. bouchonii x retroflexus)` → `Amaranthus x ralletii Contré`
* Remove subgenus information: `Acartia (Acanthacartia) tonsa` → `Acartia tonsa`
* Add the correct infraspecific indicator: `Amaranthus hybridus hybridus` → `Amaranthus hybridus var. hybridus`

We update names to force a certain synonymy:

* The suggested synonym is incorrect: `Aster divaricatus` (indicated as a synonym of `Croptilon divaricatum`, which we consider incorrect) → `Eurybia divaricata`
* GBIF suggests multiple matches: `Mimulus guttatus` → `Erythranthe guttata`

We do NOT update names:

* GBIF matches them to the correct accepted species: `Mustela vison` → Don't update to `Neovison vison`

## Verifying synonymy

* We initially indicate all matching names that GBIF considers synonyms as `verify: SYNONYM`
* If the only difference between the accepted name and the synonym name is (a variation) in the authorship, we indicate: `ok: SYNONYM author variation`.
* If the accepted name is listed in the source dataset as a synonym (field `synonym`), we indicate `ok: SYNONYM listed`. The authors need to be similar though.
* If the accepted name was verified as a valid one (e.g. in an issue discussion), we indicate: `ok: SYNONYM verified`.
