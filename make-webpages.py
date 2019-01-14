#!/usr/bin/env python3

import sys
import os
import re

from collections import defaultdict

preds = defaultdict(dict)

axiom_files = [
    '01 Eventualities.md',
    '02 Traditional Set Theory.md',
    '03 Substitution, Typical Elements, and Instances.md',
    '04 Logic Reified.md',
    '05 Functions and Sequences.md',
    '06 Composite Entities.md',
    '07 Defeasability.md',
    '08 Scales.md',
    '09 Arithmetic.md',
    '10 Change of State.md',
    '11 Causality.md',
    '12 Time.md',
    '13 Event Structure.md',
    '14 Space.md',
    '15 Persons.md',
    '16 Modality.md',
    'DFCEs.md',
    'Conflict.md']

bad_preds = ['forall', 'exists', 'iff', 'if', 'and', 'equal', 'not', 'or']


def is_lexical(s):
    return s.endswith('-in') or s.endswith('-vb') or s.endswith('-nn') \
        or s.endswith('-adj') or s.endswith('-adv')


# Read all definitions first.
for fname in axiom_files:
    in_gloss = False
    predname = ''
    with open('axioms/' + fname, 'r') as fin:
        for line in fin:
            line = line.rstrip()
            if not line:
                continue
            if line[0] == '-':
                m = re.match(r'- `(\(([^ ]+) [^)]+\))`: (.+)$', line)
                if not m:
                    continue
                predication = m.group(1)
                predname = m.group(2)
                if predname == "imply'":
                    predname = "imply"
                gloss = m.group(3)
                preds[predname]['predication'] = predication
                preds[predname]['gloss'] = gloss
                in_gloss = True
            elif line[0] == ' ' and in_gloss:
                preds[predname]['gloss'] += line
            elif line == '' or '#' in line or '(' in line:
                in_gloss = False

for fname in axiom_files:
    with open('axioms/' + fname, 'r') as fin:
        in_gloss = False
        gloss = ''

        in_axiom = False
        axiom = ''

        for line in fin:
            line = line.rstrip()

            if not line:
                in_gloss = False
                continue

            if not in_gloss and re.match('^[0-9A-Z`][0-9A-Za-z ]', line):
                in_gloss = True
                gloss = re.sub('^[0-9.]+ ', '', line)
                if re.match(r'^[0-9]+.[0-9]+$', gloss):
                    gloss = ''
            elif line == '```':
                in_gloss = False
                if in_axiom:
                    in_axiom = False
                    # Done reading an axiom; process it.

                    # Find all predicates used in the axiom and add the axiom
                    # to the entry for those predicates.
                    # Ignore variables.
                    formatted_axiom = axiom
                    proc_ax = re.sub(r'\(forall \([^)]+\)', '', axiom)
                    proc_ax = re.sub(r'\(exists \([^)]+\)', '', proc_ax)
                    to_index = set()
                    for pred in re.findall(r"\([^ ()]+ ", proc_ax):
                        pred = pred[1:].strip()
                        if pred not in preds:
                            pred = pred.replace("'", "")
                        if pred in bad_preds:
                            continue
                        if pred.startswith('etc'):
                            continue
                        to_index.add(pred)
                        formatted_axiom = formatted_axiom.replace(
                            '(' + pred + ' ',
                            '(<a href="../' + pred + '">' + pred + '</a> ')
                        formatted_axiom = formatted_axiom.replace(
                            '(' + pred + '\' ',
                            '(<a href="../' + pred + '">' + pred + '</a>\' ')
                    formatted_axiom = '<pre>\n' + formatted_axiom + '</pre>\n'
                    if gloss:
                        gloss = re.sub(r'`([^`]+)`', r'<code>\1</code>',
                                       gloss)
                        gloss = re.sub(r' -- ', ' &ndash; ', gloss)
                        gloss = re.sub(r' "', ' &ldquo;', gloss)
                        gloss = re.sub(r'"([ .,])', r'&rdquo;\1', gloss)
                        formatted_axiom = '<p>' + gloss + '</p>\n' + \
                                          formatted_axiom
                        gloss = ''

                    # If it's a characterizing axiom for a predicate,
                    # add it to the predicate's entry.
                    m = re.match(r'\(forall \([^)]+\)[^(]+\(iff? \(([^ ]+)',
                                 axiom)
                    if m:
                        pred = m.group(1)
                        if pred not in preds:
                            pred = pred.replace("'", "")
                        if pred not in bad_preds:
                            if 'characterizing' not in preds[pred]:
                                preds[pred]['characterizing'] = []
                            preds[pred]['characterizing'].append(
                                formatted_axiom)

                    for pred in to_index:
                        if (formatted_axiom not in
                            preds[pred].get('characterizing', [])):
                            if 'all axioms' not in preds[pred]:
                                preds[pred]['all axioms'] = []
                            preds[pred]['all axioms'].append(formatted_axiom)
                else:
                    in_axiom = True
                    axiom = ''
            elif in_axiom:
                axiom += line + '\n'
            elif in_gloss:
                gloss += ' '+ line

def ensure_dir(file_path):
    directory = os.path.dirname(file_path)
    if not os.path.exists(directory):
        os.makedirs(directory)


html_header = """
<!DOCTYPE html>

<html lang="en">

<head>
<meta charset="utf-8">
<title>Predicate: %s</title>
<link rel="stylesheet"
      href="https://fonts.googleapis.com/css?family=Lato:400">
<link rel="stylesheet"
      href="https://fonts.googleapis.com/css?family=Inconsolata">
<link rel="stylesheet" type="text/css" media="all" href="../style.css">
</head>

<body>
<header>
<nav>
<ul>
<li><a href="../">&laquo; Index of Predicates</a></li>
</ul>
</nav>
<h1>Predicate: <code>%s</code></h1>
</header>
"""


html_header_index = """
<!DOCTYPE html>

<html lang="en">

<head>
<meta charset="utf-8">
<title>Index of Predicates</title>
<link rel="stylesheet"
      href="https://fonts.googleapis.com/css?family=Lato:400">
<link rel="stylesheet"
      href="https://fonts.googleapis.com/css?family=Inconsolata">
<link rel="stylesheet" type="text/css" media="all" href="style.css">
</head>

<body>
<header>
<h1>Index of Predicates</h1>
</header>
"""

html_footer = """
</body>

</html>
"""

ensure_dir('docs/index.html')
with open('docs/index.html', 'w') as fout:
    fout.write(html_header_index)
    fout.write('<h2>General</h2>\n')
    fout.write('<ul>\n')
    for pred in sorted(preds):
        if not is_lexical(pred):
            fout.write('<li><a href="' + pred + '"><code>' + pred +
                       '</code></a></li>\n')
    fout.write('</ul>\n')
    fout.write('<h2>Lexical</h2>\n')
    fout.write('<ul>\n')
    for pred in sorted(preds):
        if is_lexical(pred):
            fout.write('<li><a href="' + pred + '"><code>' + pred +
                       '</code></a></li>\n')
    fout.write('</ul>\n')
    fout.write(html_footer)

for pred in preds:
    fname = 'docs/' + pred + '/index.html'
    ensure_dir(fname)
    with open(fname, 'w') as fout:
        fout.write(html_header % (pred, pred))
        if 'predication' in preds[pred]:
            fout.write('<section>\n')
            fout.write('<h2>Summary</h2>\n')
            fout.write('<pre>' + preds[pred]['predication'] + '</pre>')
            fout.write('<p>' + re.sub(r'`([^`]+)`', r'<code>\1</code>',
                                      preds[pred]['gloss']) + '</p>\n')
            fout.write('</section>\n')
        if 'characterizing' in preds[pred]:
            fout.write('<section>\n')
            fout.write('<h2>Characterizing Axioms</h2>\n')
            for axiom in preds[pred]['characterizing']:
                fout.write('<div class="axiom">\n')
                fout.write(axiom)
                fout.write('</div>')
            fout.write('</section>\n')
        if 'all axioms' in preds[pred]:
            fout.write('<section>\n')
            fout.write('<h2>Additional Axioms</h2>\n')
            for axiom in preds[pred]['all axioms']:
                fout.write('<div class="axiom">\n')
                fout.write(axiom)
                fout.write('</div>\n')
            fout.write('</section>\n')
        fout.write(html_footer)
