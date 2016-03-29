# Register of alien species in Belgium

In this repository, we plan to create an open, consolidated register of alien species in Belgium, by aggregating different source datasets.

## Source datasets

Source datasets are [described here](source-datasets).

## Process

1. Format data to valid tab-separated values
2. Define common terms (columns we want to keep):

        taxonID
        datasetName
        scientificName
        synonym
        kingdom
        phylum
        class
        order
        family
        genus
        specificEpithet
        subspecies
        taxonGroup
        vernacularNameEN
        vernacularNameNL        
        vernacularNameFR
        status
        statusCertainty
        BFIS
        ISEIA
        spatialDistribution
        invasiveness
        introductionPathway
        introductionMode
        habitat
        origin
        presenceBE
        presenceFL
        presenceWA
        presenceBR
        presenceBECoast
        presenceBPNS
        presenceBEEZ
        firstObservationYearBE
        firstObservationYearFL
        latestObservationYearBE
        source
        sourceID
        riskAnalysis
        publicationStatus
        notes

3. Process the source datasets, to:

    * Rename the columns we want to keep to their common names (defined in [this spreadsheet](https://docs.google.com/spreadsheets/d/1KJX6QBhv2xmDffYtXGt6FHV41Pm_eQjcUrDqxZxouvQ/edit?ts=56c18641#gid=0))
    * Remove the columns we are not planning to use
    * Add the other common terms
    * Sort the columns in the order provided above

4. From the root of the repository, concatenate the common term datasets with:

    ```shell
    csvcat --skip-headers source-datasets/fishes/data-with-common-terms.tsv source-datasets/harmonia/data-with-common-terms.tsv source-datasets/macroinvertebrates/data-with-common-terms.tsv source-datasets/plants/data-with-common-terms.tsv source-datasets/rinse/data-with-common-terms.tsv source-datasets/rinse-annex-b/data-with-common-terms.tsv source-datasets/wrims/data-with-common-terms.tsv > data/concatenated-without-gbif-match.tsv
    ```
