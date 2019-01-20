#!/usr/bin/env python3

# Convert Common Logic axioms to Philip format
# Jonathan Gordon, 2017-11-01

# To do:
# - 'or' is tricky to automatically convert.

import sys
import re

from sexpdata import loads, dumps, Symbol


def fix_pred(pred):
    if isinstance(pred, list):
        return list(map(fix_pred, pred))
    if isinstance(pred, Symbol):
        pred = dumps(pred)
        pred = pred.replace('*', 'star')
        return Symbol(pred)
    return pred

etc_count = 1

def convert(a, etc_vars=None):
    global etc_count

    if etc_vars == None:
        etc_vars = set()

    if len(a) == 0:
        return []

    item = a[0]
    if isinstance(item, list):
        item = convert(a[0], etc_vars)

    # Skip the variables too.
    if item in [Symbol('forall'), Symbol('exists')]:
        for var in a[1]:
            etc_vars.add(dumps(var))
        return convert(a[2], etc_vars)

    if item == Symbol('if'):
        item = Symbol('=>')
    elif item == Symbol('iff'):
        item = Symbol('<=>')
    elif item == Symbol('and'):
        item = Symbol('^')
    elif item == Symbol('etc'):
        item = Symbol('etc' + str(etc_count))
        etc_count += 1
        return [item] + [loads(x) for x in sorted(list(etc_vars))]
    return [fix_pred(item)] + convert(a[1:], etc_vars)


if __name__ == '__main__':
    axioms_text = open(sys.argv[1]).read()

    for line in axioms_text.splitlines():
        try:
            s = loads(line)
            axiom = convert(s)
        except:
            print('Error:', line, file=sys.stderr)
            sys.exit()
        print('(B ' + dumps(axiom).replace(" '", "P ") + ')')
