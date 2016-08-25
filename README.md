# Checklist of alien species in Belgium

## Rationale

Our goal is to create an open, consolidated checklist of alien species in Belgium, by aggregating different source datasets. While working on this project, we discovered that creating such a checklist in a repeatable way is hindered severly by the fact that the source datasets are not published in a standardized format. We'll therefore tackle this project in two steps:

1. Create a first checklist via a non-repeatable process. This should help us get a first consolidated list, meanwhile discovering and solving issues with taxonomy and standardization.
2. Create a second checklist via a repeatable process, by publishing the source datasets as standardized Darwin Core Archives, and registering those with GBIF, from which the data can be queried and consolidated. Lessons learned in the first step should help us do this efficiently.

## Non-repeatable process

### Process source datasets

1. Choose and download [source datasets](data/raw)
2. Format the data to tab-delimited values with Open Refine
3. Define [common terms](data/vocabularies/common-terms.tsv) for all source datasets
4. Map the source datasets to the common terms schema, using [this mapping file](data/vocabularies/common-terms-mapping.tsv).
5. Concatenate all source datasetes using:

    ```shell
    csvcat --skip-headers data/interim/fishes/data-with-common-terms.tsv data/interim/harmonia/data-with-common-terms.tsv data/interim/macroinvertebrates/data-with-common-terms.tsv data/interim/plants/data-with-common-terms.tsv data/interim/rinse/data-with-common-terms.tsv data/interim/rinse-annex-b/data-with-common-terms.tsv data/interim/wrims/data-with-common-terms.tsv > data/interim/concatenated.tsv
    ```

### Process concatenated data

1. Copy concatenated file to [data/processed/checklist.tsv](data/processed/checklist.tsv)
1. Match scientific names to the GBIF backbone taxonomy (assuming `gbif_species_name_extraction.py` is locally available):

    ```shell
    python ../invasive-t0-occurrences/src/utilities/gbif_species_name_extraction/gbif_species_name_extraction.py data/processed/checklist.tsv data/processed/checklist.tsv --update --namecol scientificName --kingdomcol kingdom --strict --api_terms usageKey scientificName canonicalName status rank matchType
    ```

2. Review any issues (see [this procedure](data/processed/README.md) for updating names).
3. Define [controlled vocabularies](data/vocabularies) for the terms we're interested in.
4. Map the current values to controlled vocabularies, using the `-mapping`-files in vocabularies directory.

## Repeatable process

1. Publish a `alien-macroinvertebrates-checklist`
