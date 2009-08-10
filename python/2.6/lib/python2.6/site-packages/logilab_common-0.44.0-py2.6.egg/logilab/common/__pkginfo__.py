"""logilab.common packaging information.

:copyright: 2000-2009 LOGILAB S.A. (Paris, FRANCE), all rights reserved.
:contact: http://www.logilab.fr/ -- mailto:contact@logilab.fr
:license: General Public License version 2 - http://www.gnu.org/licenses
"""
__docformat__ = "restructuredtext en"

distname = 'logilab-common'
modname = 'common'
numversion = (0, 44, 0)
version = '.'.join([str(num) for num in numversion])

license = 'GPL'
copyright = '''Copyright (c) 2003-2009 LOGILAB S.A. (Paris, FRANCE).
http://www.logilab.fr/ -- mailto:contact@logilab.fr'''

author = "Logilab"
author_email = "devel@logilab.fr"

short_desc = "useful miscellaneous modules used by Logilab projects"

long_desc = """logilab-common is a collection of low-level Python packages and \
modules,
 designed to ease:
  * handling command line options and configuration files
  * writing interactive command line tools
  * manipulation files and character strings
  * interfacing to OmniORB
  * generating of SQL queries
  * running unit tests
  * manipulating tree structures
  * accessing RDBMS (currently postgreSQL, mysql and sqlite)
  * generating text and HTML reports
  * logging
  * more...
"""


web = "http://www.logilab.org/project/%s" % distname
ftp = "ftp://ftp.logilab.org/pub/%s" % modname
mailinglist = "mailto://python-projects@lists.logilab.org"

subpackage_of = 'logilab'
subpackage_master = True

scripts = ('bin/pytest',)
from os.path import join
include_dirs = [join('test', 'data')]
pyversions = ['2.3', '2.4', '2.5']
debian_maintainer = 'Alexandre Fayolle'
debian_maintainer_email = 'afayolle@debian.org'
