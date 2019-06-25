# Proof of concept for a checklist of alien species in Belgium

## Rationale

This repository contains an **archived 2016 proof of concept** for creating a checklist of alien species in Belgium from different sources. Many of the concepts tried here are used for the _Global Register of Introduced and Invasive Species - Belgium_, an open, reproducible checklist of alien species in Belgium created as part of the [TrIAS project](http://trias-project.be). See https://github.com/trias-project/unified-checklist for more information.

## Process

1. Choose and download [source datasets](data/raw)
1. Format the data to tab-delimited values with Open Refine
1. Define [common terms](data/vocabularies/common-terms.tsv) for all source datasets
1. Map the source datasets to the common terms schema, using [this mapping file](data/vocabularies/common-terms-mapping.tsv).
1. Concatenate all source datasets using:

    ```shell
    csvcat --skip-headers data/interim/fishes/data-with-common-terms.tsv data/interim/harmonia/data-with-common-terms.tsv data/interim/macroinvertebrates/data-with-common-terms.tsv data/interim/plants/data-with-common-terms.tsv data/interim/rinse/data-with-common-terms.tsv data/interim/rinse-annex-b/data-with-common-terms.tsv data/interim/t0/data-with-common-terms.tsv data/interim/wrims/data-with-common-terms.tsv > data/interim/concatenated-checklist.tsv
    ```
    Up to this point, all steps are repeatable. The rest is not.

1. Copy concatenated file to [data/interim/verified-checklist.tsv](data/interim/verified-checklist.tsv).
1. Add a number of columns.
1. Define [controlled vocabularies](data/vocabularies) for the terms we're interested in.
1. Map the current values to controlled vocabularies, using the `-mapping`-files in vocabularies directory.
1. Match scientific names to the GBIF backbone taxonomy (assuming [inbo-pyutils](https://github.com/inbo/inbo-pyutils) is locally available):

    ```shell
    python ../inbo-pyutils/gbif/gbif_name_match/gbif_species_name_match.py data/interim/verified-checklist.tsv data/interim/verified-checklist.tsv --update --namecol scientificName --kingdomcol kingdom --strict --api_terms usageKey scientificName canonicalName status rank matchType
    ```

1. Automatically update `nameMatchValidation` column for synonyms that have been verified:

    ```shell
    python ../inbo-pyutils/gbif/verify_synonyms/verify_synonyms.py data/interim/verified-checklist.tsv data/interim/verified-checklist.tsv --synonym_file data/vocabularies/verified-synonyms.tsv --usagekeycol gbifapi_usageKey --acceptedkeycol gbifapi_acceptedKey --taxonomicstatuscol gbifapi_status --outputcol nameMatchValidation
    ```

1. Review any remaining issues (see [this procedure](docs/README.md) for updating names).
1. Aggregate the checklist with [this notebook](notebooks/1-peterdesmet-create-aggregated-checklist.ipynb) to create this [the final checklist](data/processed/aggregated-checklist.tsv).

## Contributors

[List of contributors](https://github.com/inbo/alien-species-checklist/contributors)

## License

[MIT License](LICENSE)
