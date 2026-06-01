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

def is_useful_text(s: str) -> bool:
    return bool(s) and bool(s.strip())

def strip_ns(tag: str) -> str:
    return tag.split('}', 1)[1] if '}' in tag else tag

def norm_text(s: str) -> str:
    # Normaliza espacios y saltos de línea múltiples a un solo espacio
    return ' '.join((s or '').split())

def walk(elem, path: str, out: dict):
    # Capturar texto útil aunque existan hijas/os
    text = norm_text(elem.text or '')
    if is_useful_text(text) and path:
        out[path] = text

    # Recorrer hijas/os
    for child in list(elem):
        tag = strip_ns(child.tag)  # preserva guiones
        child_path = f"{path}.{tag}" if path else tag
        walk(child, child_path, out)
        # Si hubiera tail text relevante, podría procesarse aquí si interesara

def xml_to_labels_dict(xml_path):
    tree = ET.parse(xml_path)
    root = tree.getroot()
    labels = {}

    # Idioma (xml:lang)
    lang = root.attrib.get('{%s}lang' % XML_NS['xml'])
    if lang:
        labels['@xml:lang'] = lang

    # Aplanar: arrancamos desde el tag raíz para evitar path vacío
    root_tag = strip_ns(root.tag)
    walk(root, root_tag, labels)

    # Quitar el prefijo del root para que las claves empiecen en el primer nivel real
    labels = {
        (k[len(root_tag) + 1:] if k.startswith(root_tag + '.') else k): v
        for k, v in labels.items()
    }

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