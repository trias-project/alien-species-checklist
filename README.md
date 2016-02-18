# Register of alien species in Belgium

In this repository, we plan to create an open, consolidated register of alien species in Belgium, by aggregating different source datasets.

## Source datasets

Source datasets are [described here](source-datasets).

## Process

1. Format data to valid tab-separated values
2. Define common terms (columns we want to keep):

        BFIS
        class
        datasetName
        family
        firstObservationYearBE
        firstObservationYearFL
        genus
        habitat
        introductionMode
        introductionPathway
        invasiveness
        ISEIA
        kingdom
        latestObservationYearBE
        notes
        order
        origin
        phylum
        presenceBE
        presenceBR
        presenceFL
        presenceWA
        publicationStatus
        riskAnalysis
        scientificName
        source
        sourceID
        spatialDistribution
        specificEpithet
        status
        statusCertainty
        subspecies
        synonym
        taxonGroup
        taxonID
        vernacularNameEN
        vernacularNameFR
        vernacularNameNL

3. Process the source datasets, to:

    * Rename the columns we want to keep to their common names (defined in [this spreadsheet](https://docs.google.com/spreadsheets/d/1KJX6QBhv2xmDffYtXGt6FHV41Pm_eQjcUrDqxZxouvQ/edit?ts=56c18641#gid=0)
    * Remove the columns we are not planning to use
    * Add the other common terms
    * Order the columns alphabetically


