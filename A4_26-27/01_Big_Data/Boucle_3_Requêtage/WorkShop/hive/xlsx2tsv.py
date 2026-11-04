#!/usr/bin/env python3
"""Convertit la premiere feuille d'un .xlsx en TSV (stdlib uniquement, pas d'openpyxl).
Usage : python3 -I xlsx2tsv.py fichier.xlsx > sortie.tsv"""
import sys, zipfile, re
import xml.etree.ElementTree as ET

NS = {"m": "http://schemas.openxmlformats.org/spreadsheetml/2006/main"}

def col_index(ref):
    letters = re.match(r"[A-Z]+", ref).group(0)
    n = 0
    for ch in letters:
        n = n * 26 + ord(ch) - 64
    return n - 1

def main(path):
    z = zipfile.ZipFile(path)
    shared = []
    if "xl/sharedStrings.xml" in z.namelist():
        for si in ET.fromstring(z.read("xl/sharedStrings.xml")).findall("m:si", NS):
            shared.append("".join(t.text or "" for t in si.iter("{%s}t" % NS["m"])))
    sheet = sorted(n for n in z.namelist() if re.match(r"xl/worksheets/sheet\d+\.xml", n))[0]
    out = sys.stdout
    for _, row in ET.iterparse(z.open(sheet)):
        if row.tag != "{%s}row" % NS["m"]:
            continue
        vals = {}
        for c in row.findall("m:c", NS):
            v = c.find("m:v", NS)
            t = c.get("t")
            if t == "inlineStr":
                txt = "".join(x.text or "" for x in c.iter("{%s}t" % NS["m"]))
            elif v is None:
                txt = ""
            elif t == "s":
                txt = shared[int(v.text)]
            else:
                txt = v.text
            vals[col_index(c.get("r"))] = txt.replace("\t", " ").replace("\r", " ").replace("\n", " ")
        if vals:
            out.write("\t".join(vals.get(i, "") for i in range(max(vals) + 1)) + "\n")
        row.clear()

if __name__ == "__main__":
    main(sys.argv[1])
