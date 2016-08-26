# Verify taxonomy synonyms against known synonym list

## Introduction
When performing a taxonomic matching against the GBIF (or any other) backbone,  an exact match is not always guaranteed. When getting a SYNONYM as status, it needs further specification on how to handle these records. 

## Aim
In order to build up more knowledge about the potential causes of the SYNONYM and the potential solutions, a continuously updated compilation of known SYNONYM matches can be used to do a first verification on the output of a GBIF matching. 

This small `verify_synonyms.py`feature enables this functionality. For a given input file, the SYNONYM matches are checked against a provided list of synonyms. For each of the SYNONYM matches of the input file, the status is added in an additional (or update of an existing) column. When the SYNONYM match is not in the existing list, these records will remain empty. Hence, the users knows which SYNONYM matches need further consideration.

## Functionality

The functionality can be loaded within Python itself by importin the function `verify_synonym` or by running the script from the command line.

### Command line function
To check the functionality of the command line function, request for help as follows:

```python
python verify_synonyms.py --help
```

The different arguments are as follows:

**Positional arguments:**
 * `input_file`: the relative path and filename to the input file for which the SYNONYM matches need to be verified
 * `output_file`: output file name (can be same as the input file)

**Optional arguments**:
 * `--synonym_file`: relative path and filename to the file containing the synonym status information
 * `--usagekeycol`: column name of the input file containing the gbif usage keys (default when not provided: `gbifapi_usageKey`)
 *  `--acceptedkeycol`: column name of the input file containing the gbif accepted keys (default when not provided: `gbifapi_acceptedKey`)
 * `--taxonomicstatuscol`: column name of the input file containing the gbif taxonomic matchin status information, e.g. SYNONYM (default when not provided: `gbifapi_status`)
 * `--outputcol`: column name of the output file to provide the information about the synonym status (default when not provided: `nameMatchValidation`)

As an example, the following code will execute the verification:

```bash
python verify_synonyms.py checklist.tsv temp_out.tsv --synonym_file verified-synonyms.tsv --usagekeycol gbifapi_usageKey --acceptedkeycol gbifapi_acceptedKey --taxonomicstatuscol gbifapi_status --outputcol nameMatchValidation
```

When using the default naming in the columns, the command can actually be simplified to:

```bash
python verify_synonyms.py checklist.tsv temp_out.tsv --synonym_file verified-synonyms.tsv
```

### Python function
When running the function inside Python, make sure the location is added to the PATH in order to enable the import of the function. Furthermore, the functionality is complete analog to the cmd-version as follows:

```python
from verify_synonyms import verify_synonym

verify_synonym(checklist.tsv, 
				temp_out.tsv, 
				verified-synonyms.tsv, 
				usagekeycol='gbifapi_usageKey', 
				acceptedkeycol='gbifapi_acceptedKey', 
				taxonomicstatuscol='gbifapi_status', 
				outputcol='nameMatchValidation'
```




