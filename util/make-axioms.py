#!/usr/bin/env python3

import sys
import re
import click

@click.command()
@click.argument('fname', type=click.Path(exists=True))
def main(fname):
    with open(fname, 'r') as fin:
        md = fin.read()

    for axiom in re.findall('```([^`]+)```', md):
        # Remove comments
        axiom = re.sub(r';.+\n', '', axiom)
        oneline = re.sub(r'[\n ]+', ' ', axiom).strip()
        if oneline.count('(') != oneline.count(')'):
            print('Error: Mismatched parentheses', oneline, file=sys.stderr)
            sys.exit()
        print(oneline)


if __name__ == '__main__':
    main()
