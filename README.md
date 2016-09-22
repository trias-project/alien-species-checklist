# Checklist of alien species in Belgium

## Rationale

Our goal is to create an open, consolidated checklist of alien species in Belgium, by aggregating different source datasets. While working on this project, we discovered that creating such a checklist in a repeatable way is hindered severely by the fact that the source datasets are not published in a standardized format. We'll therefore tackle this project in two steps:

1. Create a first checklist via a non-repeatable process. This should help us get a first consolidated list, meanwhile discovering and solving issues with taxonomy and standardization.
2. Create a second checklist via a repeatable process, by publishing the source datasets as standardized Darwin Core Archives, and registering those with GBIF, from which the data can be queried and consolidated. Lessons learned in the first step should help us do this efficiently.

## Non-repeatable process

### Process source datasets

1. Choose and download [source datasets](data/raw)
2. Format the data to tab-delimited values with Open Refine
3. Define [common terms](data/vocabularies/common-terms.tsv) for all source datasets
4. Map the source datasets to the common terms schema, using [this mapping file](data/vocabularies/common-terms-mapping.tsv).
5. Concatenate all source datasets using:

    ```shell
    csvcat --skip-headers data/interim/fishes/data-with-common-terms.tsv data/interim/harmonia/data-with-common-terms.tsv data/interim/macroinvertebrates/data-with-common-terms.tsv data/interim/plants/data-with-common-terms.tsv data/interim/rinse/data-with-common-terms.tsv data/interim/rinse-annex-b/data-with-common-terms.tsv data/interim/t0/data-with-common-terms.tsv data/interim/wrims/data-with-common-terms.tsv > data/interim/concatenated-checklist.tsv
    ```

Up to this point, all steps are repeatable. The rest is not.

### Process concatenated data

1. Copy concatenated file to [data/interim/verified-checklist.tsv](data/interim/verified-checklist.tsv).
2. Add a number of columns.
3. Define [controlled vocabularies](data/vocabularies) for the terms we're interested in.
4. Map the current values to controlled vocabularies, using the `-mapping`-files in vocabularies directory.
5. Match scientific names to the GBIF backbone taxonomy (assuming [inbo-pyutils](https://github.com/inbo/inbo-pyutils) is locally available):

    ```shell
    python ../inbo-pyutils/gbif/gbif_name_match/gbif_species_name_match.py data/interim/verified-checklist.tsv data/interim/verified-checklist.tsv --update --namecol scientificName --kingdomcol kingdom --strict --api_terms usageKey scientificName canonicalName status rank matchType
    ```

6. Automatically update `nameMatchValidation` column for synonyms that have been verified:

    ```shell
    python ../inbo-pyutils/gbif/verify_synonyms/verify_synonyms.py data/interim/verified-checklist.tsv data/interim/verified-checklist.tsv --synonym_file data/vocabularies/verified-synonyms.tsv --usagekeycol gbifapi_usageKey --acceptedkeycol gbifapi_acceptedKey --taxonomicstatuscol gbifapi_status --outputcol nameMatchValidation

7. Review any remaining issues (see [this procedure](docs/README.md) for updating names).
8. Aggregate the checklist with [this notebook](notebooks/1-peterdesmet-create-aggregated-checklist.ipynb) to create this [the final checklist](data/processed/aggregated-checklist.tsv).

## Repeatable process

Described in TrIAS proposal.
