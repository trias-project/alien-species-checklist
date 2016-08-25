
import sys
import argparse

import pandas as pd

# Way to call script:

# verify_synonyms.py input_file output_file --synonymlist --usagekeycol --acceptedkeycol --remarkcol

def verify_synonym(input_file, output_file, synonym_file,
                   usagekeycol='gbifapi_usageKey', 
                   acceptedkeycol='gbifapi_acceptedKey', 
                   api_status='gbifapi_status',
                   remarkcol='nameMatchValidation'):
    """verify if more information on the synonyms is already present
    Find out which of the synonyms were already registered as defined by the 
    synonym_file, by checking the match between the usageKey AND acceptedKey
    as provided by GBIF. When a match is found, the status as registered in the
    synonym-file is provided.

    Parameters:
    --------
    input_file: str (filepath)
    
    output_file: str (filepath)
    
    usagekeycol: str (default: gbifapi_usageKey)
        column name with the usagekey for input_file 
    acceptedkeycol: str (default: gbifapi_acceptedKey)
        column name with the acceptedKey for input_file  
    api_status: str (default: gbif_apistatus)
        column name with the API status of GBIF for input_file  
    remarkcol: str
        column name to put the remarks of the verification of the input file
        
    Remarks:
    --------
    For the synonym_file, the names of the usagekey, acceptedkey and status
    columns are fixed and should be equal to respectively `gbifapi_usageKey`,  
    `gbifapi_acceptedKey` and 'status'
    """
    # Reading in the files (csv or tsv)
    if input_file.endswith('tsv'):
        delimiter = '\t'
    else:
        delimiter = ','
    input_file = pd.read_csv(input_file, sep=delimiter)                

    # read the synonyms file    
    synonyms = pd.read_csv(synonym_file, sep='\t')
    
    #extract useful columns from synonym file (expected to be fixed)
    synonyms_subset = synonyms[["gbifapi_usageKey", "gbifapi_acceptedKey", "status"]]
    
    # Check the matches by doing a join of the inputfile with the synonym
    verified = pd.merge(input_file, synonyms_subset, how='left',
                        left_on=[usagekeycol, acceptedkeycol], 
                        right_on=["gbifapi_usageKey", "gbifapi_acceptedKey"])
    
    # overwrite for SYNONYM values when already present
    if remarkcol in verified.clumns:
        verified.loc[verified[api_status] == "SYNONYM", remarkcol] = \
            verified.loc[verified[api_status] == "SYNONYM", 'status']
        verified = verified.drop('status', axis=1)
    else:
        verified = verified.rename(columns={'status' : remarkcol})        

    verified.to_csv(output_file, sep=delimiter, index=False, 
                        encoding='utf-8')    


def main(argv=None):
    """
    Use usagekeycol and acceptedkeycol to lookup a match in the synonymlist

    * If match found and status = ok:
        populate statuscol with: ok: SYNONYM verified
    * If match found and status <> ok:
        populate statuscol with: verify: SYNONYM <status>
    * If no match found: 
        do nothing    
    """    
    parser = argparse.ArgumentParser(description="""Lookup a match in the 
        synonymlist. If match and status is ok, the record is enlisted as 
        SYNONYM verified; if match but status is not ok, the record is 
        provided of a verify status. If no match is found, nothing is done.
        """)    
    
    parser.add_argument('input_file', type=str,
                        help='the relative path and filename containing the usage and acceptedkey col')
                       
    parser.add_argument('output_file', action='store', default=None, 
                        help='output file name, can be same as input')              
    
    parser.add_argument('--synonymlist', type=str,
                        action='store', default=None, 
                        help='')                                            

    parser.add_argument('--usagekeycol', type=str,
                        action='store', default='gbifapi_usageKey', 
                        help='')                                            

    parser.add_argument('--acceptedkeycol', type=str,
                        action='store', default='gbifapi_acceptedKey', 
                        help='')  
    parser.add_argument('--statuscol', type=str,
                        action='store', default='status', 
                        help='')                        

    args = parser.parse_args()
    print(args)    
    print(args.inputfile)    
    
    print("Verification of the synonym names...")
    verify_synonym(args.input_file, args.output_file,
                   args.synonym_file,
                   args.usagekeycol,
                   args.acceptedkeycol,
                   args.statuscol
                   ) 
    print("saving to file...done!")

if __name__ == "__main__":
    sys.exit(main())    
