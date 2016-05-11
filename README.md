# Checklist of alien species in Belgium

## Rationale

Our goal is to create an open, consolidated checklist of alien species in Belgium, by aggregating different source datasets. While working on this project, we discovered that creating such a checklist in a repeatable way is hindered severly by the fact that the source datasets are not published in a standardized format. We'll therefore tackle this project in two steps:

1. Create a first checklist via a non-repeatable process. This should help us get a first consolidated list, meanwhile discovering and solving issues with taxonomy and standardization.
2. Create a second checklist via a repeatable process, by publishing the source datasets as standardized Darwin Core Archives, and registering those with GBIF, from which the data can be queried and consolidated. Lessons learned in the first step should help us do this efficiently.

## Non-repeatable process

### Process source datasets

1. Choose and download [source datasets](source-datasets)
2. Format the data to tab-delimited values
3. Define [common terms](utilities/common-terms.csv) for all source datasets
4. Map the source datasets to the common terms schema (using the mapping defined in [this spreadsheet](https://docs.google.com/spreadsheets/d/1KJX6QBhv2xmDffYtXGt6FHV41Pm_eQjcUrDqxZxouvQ/edit?ts=56c18641#gid=0))
5. Concatenate all source datasetes using:

    ```shell
    csvcat --skip-headers source-datasets/fishes/data-with-common-terms.tsv source-datasets/harmonia/data-with-common-terms.tsv source-datasets/macroinvertebrates/data-with-common-terms.tsv source-datasets/plants/data-with-common-terms.tsv source-datasets/rinse/data-with-common-terms.tsv source-datasets/rinse-annex-b/data-with-common-terms.tsv source-datasets/wrims/data-with-common-terms.tsv > data/concatenated-without-gbif-match.tsv
    ```

### Process concatenated data

1. Match scientific names to the GBIF backbone taxonomy and review any issues
2. Define controlled vocabularies for the terms we're interested in.
3. Map the current values to controlled vocabularies, using [these mapping files](mapping).

## Repeatable process

1. Publish a `alien-macroinvertebrates-checklist`
