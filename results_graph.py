"""
Natural Language Processing for PS 1903
Aaron Paczak 
10/20/18

This is meant to provide a few graphs for observing the precision and recall of the experiements
done on the classifiers for gender in congressional speeches.

run with: 
python results_graph.py [filename of results from r program] [first session in consideration] [second session in consideration]
"""

import csv
import matplotlib.pyplot as plt
import plotly.plotly as ply
import plotly.tools as tls
import numpy as np
import argparse

"""
Object that stores all of the precision and recall values to be easily accessed.
"""
class Pred:
    def __init__(self, tp, fp, fn, tn, session):
        self.tp = int(tp)
        self.fp = int(fp)
        self.fn = int(fn)
        self.tn = int(tn)
        self.total_speeches = self.tp+self.fn+self.fp+self.tn
        self.session = session
        
    def recall(self):
        try: return self.tp/(self.tp+self.fn)
        except: return 0
    
    def precision(self):
        try: return self.tp/(self.tp+self.fp)
        except: return 1

"""
Get the command line argumnets.
"""
def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("output_file", help="The path to the output file for a given run of a certain classifier experiment.")
    parser.add_argument("first_session", help="The lower bound on congressional sessions.")
    parser.add_argument("last_session", help="The upper bound on congressional sessions.")
    args = parser.parse_args()
    return args

def main():
    args = get_args()
    output_file = args.output_file
    sessions = range(int(args.first_session), int(args.last_session)+1)

    # Get data from R program output
    cms = []
    with open(output_file, 'r') as f:
        bog = csv.reader(f, delimiter=" ")
        print(bog)
        for row,ses in zip(bog,sessions):
            print(row)
            pred = Pred(row[0], row[1], row[2], row[3], ses)
            cms.append(pred)
    
    males = []
    females = []
    with open("gender_quantities.txt", 'r') as f:
        gen = csv.reader(f, delimiter=" ")
        print(gen)
        for row in gen:
            females.append(row[0])
            males.append(row[1])

    print(males)
    print(females)

    # Make data plottable
    precisions = [ p.precision() for p in cms ]
    recalls    = [ p.recall() for p in cms ]
    tps = [ p.tp for p in cms ]
    fps = [ p.fp for p in cms ]
    fns = [ p.fn for p in cms ]
    tns = [ p.tn for p in cms ]

    print(sessions)
    print(precisions)
    print(recalls)

    # Plot
    plt.figure(1)
   
    # Precision and Recall Plot
    plt.subplot(211)
    plt.plot(sessions, precisions, 'bo', sessions, recalls, 'ro')
    plt.ylabel('Precision (Blue) and Recall (Red)')
    plt.xlabel('Congressional Session')

    # The Counts Plot
    plt.figure(2)
    bar_width = 0.35
    opacity = 0.8
    index = np.arange(len(sessions))
    tp = plt.bar(index, tps, bar_width, alpha=opacity, color='g', label='True Male')
    fn = plt.bar(index+bar_width, fns, bar_width, alpha=opacity, color='r', label='False Female')
    fp = plt.bar(index+2*bar_width, fps, bar_width, alpha=opacity,  label='False Male')
    tn = plt.bar(index+3*bar_width, tns, bar_width, alpha=opacity, color='b', label='True Female')
    plt.xlabel('Congressional Session')
    plt.ylabel('Quantity of Measurable Results')
    plt.xticks(index+bar_width, sessions) 
    plt.legend()
    plt.tight_layout()
    plt.show()

    # Male/Female Spread
    plt.figure(3)
    m = plt.bar(index, males, bar_width, alpha=opacity, color='g', label='Number of Males')
    f = plt.bar(index+bar_width, females, bar_width, alpha=opacity, color='r', label='Number of Females')
    plt.xlabel('Congressional Session')
    plt.ylabel('Quantity of Males/Females')
    plt.xticks(index+bar_width, sessions) 
    plt.legend()
    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    main()
