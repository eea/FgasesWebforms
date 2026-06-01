#!/usr/bin/env python
# coding: utf-8
"""
Convierte ficheros de labels XML a JSON plano con claves por path.
Uso:
  python tools/xml_to_json_labels.py <src_xml_dir> [dst_json_dir]
Ejemplo:
  python tools/xml_to_json_labels.py ../xml build/labels
"""

import os
import sys
import json
import xml.etree.ElementTree as ET

XML_NS = {'xml': 'http://www.w3.org/XML/1998/namespace'}

def has_element_children(elem):
    return any(list(elem))

def walk(elem, path, out):
    """Aplana el árbol: genera claves por path y guarda texto de hojas."""
    text = (elem.text or '').strip()
    if text and not has_element_children(elem):
        if path:
            out[path] = text

    for child in list(elem):
        tag = child.tag
        # Quitar namespace si lo hubiera
        if '}' in tag:
            tag = tag.split('}', 1)[1]
        child_path = f"{path}.{tag}" if path else tag
        walk(child, child_path, out)

def xml_to_labels_dict(xml_path):
    tree = ET.parse(xml_path)
    root = tree.getroot()
    labels = {}

    # Capturar idioma si existe: xml:lang en la raíz <labels>
    lang = root.attrib.get('{%s}lang' % XML_NS['xml'])
    if lang:
        labels['@xml:lang'] = lang

    # Aplanar a partir de <labels> (raíz)
    walk(root, '', labels)
    # Eliminar clave vacía si apareció
    if '' in labels:
        del labels['']

    return {'labels': labels}

def main(src_dir, dst_dir):
    os.makedirs(dst_dir, exist_ok=True)
    for fname in os.listdir(src_dir):
        if fname.lower().endswith('.xml'):
            in_path = os.path.join(src_dir, fname)
            out_name = os.path.splitext(fname)[0] + '.json'
            out_path = os.path.join(dst_dir, out_name)
            data = xml_to_labels_dict(in_path)
            with open(out_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            print(f"Generated: {out_path}")

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: xml_to_json_labels.py <src_xml_dir> [dst_json_dir]")
        sys.exit(1)
    src = sys.argv[1]
    dst = sys.argv[2] if len(sys.argv) > 2 else os.path.join(src, '..', 'json')
    main(src, dst)