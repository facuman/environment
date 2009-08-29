"""Various components of SNMP applications"""
import os
import sys
import string

def switchApiVersion(subPkg):
    pkg = os.path.split(__path__[0])[-1]
    newMod = __import__(subPkg, globals(), locals())
    realPkg = '_real_' + pkg
    if sys.modules.has_key(realPkg):
        sys.modules[pkg] = sys.modules[realPkg]
    sys.modules[realPkg] = sys.modules[pkg]
    sys.modules[pkg] = newMod

def __isSubPackage(subDir):
    if subDir and subDir[0] == 'v' and subDir[1] in string.digits \
           and len(subDir) == 2:
        return 1

if os.environ.has_key('PYSNMP_API_VERSION'):
    v = os.environ['PYSNMP_API_VERSION']
    if v:
        switchApiVersion(v)   # do not load any API
else:
    subDirs = filter(__isSubPackage, os.listdir(__path__[0]))
    subDirs.sort();
    switchApiVersion(subDirs[-1])  # take the most recent version
