#!/usr/bin/env python3

# Convert Common Logic axioms to Philip format
# Jonathan Gordon, 2017-11-01

# To do:
# - 'or' is tricky to automatically convert.

import sys

from sexpdata import loads, dumps, Symbol

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

    return [item] + convert(a[1:], etc_vars)


if __name__ == '__main__':
    axioms_text = '(' + open(sys.argv[1]).read() + ')'

    s = loads(axioms_text)
    for axiom in s:
        new_axiom = convert(axiom)
        print('(B ' + dumps(new_axiom).replace(" '", "\\' ") + ')')
