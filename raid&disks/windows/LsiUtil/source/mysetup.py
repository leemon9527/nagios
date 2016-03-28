# mysetup.py
from distutils.core import setup
import py2exe
import sys

sys.argv.append('py2exe')

setup(
    name="check_raid&disk on lsiutil",
    version="1.0.0",
    description="check_raid&disk",
    author="Leemon",
	console=[{
	'script': 'check_raid_lsiutil.py',
	}],
	options={"py2exe":{"includes":["sip"],"compressed": 1,"optimize": 2, "bundle_files": 1}},
    zipfile=None
)