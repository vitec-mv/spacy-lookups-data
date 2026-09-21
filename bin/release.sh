#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    exit 1
fi
version=$1

uv venv --clear --seed
source .venv/bin/activate
uv pip install twine

echo "Updating version to $version"
sed -i "s/__version__ = .*/__version__ = \"$version\"/" spacy_lookups_data/about.py

rm -rf build dist
python3 setup.py bdist_wheel

twine upload --repository py_packages dist/* --config-file ~/.pypirc

git add spacy_lookups_data/about.py
git commit -m "update version to $version"
git push
git tag "v$version"
git push origin "v$version"
