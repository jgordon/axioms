#!/usr/bin/env python3

import re
import click

@click.command()
@click.argument('fname', type=click.Path(exists=True))
def main(fname):
    with open(fname, 'r') as fin:
        md = fin.read()

    for axiom in re.findall('```([^`]+)```', md):
        print(re.sub(r'[\n ]+', ' ', axiom).strip())

if __name__ == '__main__':
    main()
