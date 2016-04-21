
import sys
import argparse
import itertools


def create_combinations(strlist, filename):
    """make combinations of a list of strings
    """
    with open(filename, 'w') as f:
        for i in range(0, len(strlist)+1):
            for subset in itertools.combinations(strlist, i):
                f.write(' | '.join(subset))        
                f.write('\n')
        

def main(argv=None):
    """
    Make all combinations from a set of strings 
    """    
    parser = argparse.ArgumentParser(description="""Create a textfile that 
        contains all the combinations of the input values with | as delimiter
        """)    
    
    parser.add_argument('outputfile', type=str,
                        help="""name of the file to write the output in
                             """)
                                         
    parser.add_argument('--names', type=str, nargs='+',
                        action='store', 
                        help="""set of names to make combinations with
                             """)
                        
    args = parser.parse_args() 
    
    print("Writing text file...")
    create_combinations(args.names, 
                        args.outputfile) 
    print("saving to file...done!")

if __name__ == "__main__":
    sys.exit(main())
 

 
         