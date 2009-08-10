"""
unit tests for module logilab.common.db
"""

import os
import pwd
import socket

from logilab.common.testlib import TestCase, unittest_main
from logilab.common.db import *
from logilab.common.db import PREFERED_DRIVERS
from logilab.common.adbh import (_GenericAdvFuncHelper, _SqliteAdvFuncHelper,
                                 _PGAdvFuncHelper, _MyAdvFuncHelper,
                                 FunctionDescr, get_adv_func_helper,
                                 auto_register_function)


def getlogin():
    """avoid usinng os.getlogin() because of strange tty / stdin problems
    (man 3 getlogin)
    Another solution would be to use $LOGNAME, $USER or $USERNAME
    """
    return pwd.getpwuid(os.getuid())[0]

class PreferedDriverTC(TestCase):
    def setUp(self):
        self.drivers = {"pg":[('foo', None), ('bar', None)]}
        self.drivers = {'pg' : ["foo", "bar"]}

    def testNormal(self):
        set_prefered_driver('pg','bar', self.drivers)
        self.assertEquals('bar', self.drivers['pg'][0])

    def testFailuresDb(self):
        try:
            set_prefered_driver('oracle','bar', self.drivers)
            self.fail()
        except UnknownDriver, exc:
            self.assertEquals(exc.args[0], 'Unknown database oracle')

    def testFailuresDriver(self):
        try:
            set_prefered_driver('pg','baz', self.drivers)
            self.fail()
        except UnknownDriver, exc:
            self.assertEquals(exc.args[0], 'Unknown module baz for pg')

    def testGlobalVar(self):
        # XXX: Is this test supposed to be useful ? Is it supposed to test
        #      set_prefered_driver ?
        old_drivers = PREFERED_DRIVERS['postgres'][:]
        expected = old_drivers[:]
        expected.insert(0, expected.pop(expected.index('pgdb')))
        set_prefered_driver('postgres', 'pgdb')
        self.assertEquals(PREFERED_DRIVERS['postgres'], expected)
        set_prefered_driver('postgres', 'psycopg')
        # self.assertEquals(PREFERED_DRIVERS['postgres'], old_drivers)
        expected.insert(0, expected.pop(expected.index('psycopg')))
        self.assertEquals(PREFERED_DRIVERS['postgres'], expected)


class GetCnxTC(TestCase):
    def setUp(self):
        try:
            socket.gethostbyname('hercules')
        except:
            self.skip("those tests require specific DB configuration")
        self.host = 'hercules'
        self.db = 'template1'
        self.user = getlogin()
        self.passwd = getlogin()

    def testPsyco(self):
        set_prefered_driver('postgres', 'psycopg')
        try:
            cnx = get_connection('postgres',
                                 self.host, self.db, self.user, self.passwd,
                                 quiet=1)
        except ImportError:
            self.skip('python-psycopg is not installed')

    def testPgdb(self):
        set_prefered_driver('postgres', 'pgdb')
        try:
            cnx = get_connection('postgres',
                                 self.host, self.db, self.user, self.passwd,
                                 quiet=1)
        except ImportError:
            self.skip('python-pgsql is not installed')

    def testPgsql(self):
        set_prefered_driver('postgres', 'pyPgSQL.PgSQL')
        try:
            cnx = get_connection('postgres',
                                 self.host, self.db, self.user, self.passwd,
                                 quiet=1)
        except ImportError:
            self.skip('python-pygresql is not installed')

    def testMysql(self):
        set_prefered_driver('mysql', 'MySQLdb')
        try:
            cnx = get_connection('mysql', self.host, database='', user='root',
                                 quiet=1)
        except ImportError:
            self.skip('python-mysqldb is not installed')
        except Exception, ex:
            # no mysql running ?
            import MySQLdb
            if isinstance(ex, MySQLdb.OperationalError):
                if ex.args[0] == 1045: # find MysqlDb
                    self.skip('mysql test requires a specific configuration')
                elif ex.args[0] != 2003:
                    raise
            raise

    def test_connection_wrap(self):
        """Tests the connection wrapping"""
        try:
            cnx = get_connection('postgres',
                                 self.host, self.db, self.user, self.passwd,
                                 quiet=1)
        except ImportError:
            self.skip('postgresql dbapi module not installed')
        self.failIf(isinstance(cnx, PyConnection),
                    'cnx should *not* be a PyConnection instance')
        cnx = get_connection('postgres',
                             self.host, self.db, self.user, self.passwd,
                             quiet=1, pywrap = True)
        self.failUnless(isinstance(cnx, PyConnection),
                        'cnx should be a PyConnection instance')


    def test_cursor_wrap(self):
        """Tests cursor wrapping"""
        try:
            cnx = get_connection('postgres',
                                 self.host, self.db, self.user, self.passwd,
                                 quiet=1, pywrap = True)
        except ImportError:
            self.skip('postgresql dbapi module not installed')
        cursor = cnx.cursor()
        self.failUnless(isinstance(cursor, PyCursor),
                        'cnx should be a PyCursor instance')


class DBAPIAdaptersTC(TestCase):
    """Tests DbApi adapters management"""

    def setUp(self):
        """Memorize original PREFERED_DRIVERS"""
        self.old_drivers = PREFERED_DRIVERS['postgres'][:]
        self.base_functions = dict(_GenericAdvFuncHelper.FUNCTIONS)
        self.host = 'crater.logilab.fr'
        self.db = 'gincotest2'
        self.user = 'adim'
        self.passwd = 'adim'

    def tearDown(self):
        """Reset PREFERED_DRIVERS as it was"""
        PREFERED_DRIVERS['postgres'] = self.old_drivers
        _GenericAdvFuncHelper.FUNCTIONS = self.base_functions
        _PGAdvFuncHelper.FUNCTIONS = dict(self.base_functions)
        _MyAdvFuncHelper.FUNCTIONS = dict(self.base_functions)
        _SqliteAdvFuncHelper.FUNCTIONS = dict(self.base_functions)

    def test_raise(self):
        self.assertRaises(UnknownDriver, get_dbapi_compliant_module, 'pougloup')

    def test_pgdb_types(self):
        """Tests that NUMBER really wraps all number types"""
        PREFERED_DRIVERS['postgres'] = ['pgdb']
        #set_prefered_driver('postgres', 'pgdb')
        try:
            module = get_dbapi_compliant_module('postgres')
        except ImportError:
            self.skip('postgresql pgdb module not installed')
        number_types = ('int2', 'int4', 'serial',
                        'int8', 'float4', 'float8',
                        'numeric', 'bool', 'money', 'decimal')
        for num_type in number_types:
            yield self.assertEquals, num_type, module.NUMBER
        yield self.assertNotEquals, 'char', module.NUMBER

    def test_pypgsql_getattr(self):
        """Tests the getattr() delegation for pyPgSQL"""
        set_prefered_driver('postgres', 'pyPgSQL.PgSQL')
        try:
            module = get_dbapi_compliant_module('postgres')
        except ImportError:
            self.skip('postgresql dbapi module not installed')
        try:
            binary = module.BINARY
        except AttributeError, err:
            raise
            self.fail(str(err))

    def test_adv_func_helper(self):
        try:
            module = get_dbapi_compliant_module('postgres')
        except ImportError:
            self.skip('postgresql dbapi module not installed')
        self.failUnless(isinstance(module.adv_func_helper, _PGAdvFuncHelper))
        try:
            module = get_dbapi_compliant_module('sqlite')
        except ImportError:
            self.skip('sqlite dbapi module not installed')
        self.failUnless(isinstance(module.adv_func_helper, _SqliteAdvFuncHelper))


    def test_auto_register_funcdef(self):
        class MYFUNC(FunctionDescr):
            supported_backends = ('postgres', 'sqlite',)
            name_mapping = {'postgres': 'MYFUNC',
                            'mysql': 'MYF',
                            'sqlite': 'SQLITE_MYFUNC'}
        auto_register_function(MYFUNC)

        pghelper = get_adv_func_helper('postgres')
        mshelper = get_adv_func_helper('mysql')
        slhelper = get_adv_func_helper('sqlite')
        self.failUnless('MYFUNC' in pghelper.FUNCTIONS)
        self.failUnless('MYFUNC' in slhelper.FUNCTIONS)
        self.failIf('MYFUNC' in mshelper.FUNCTIONS)


    def test_funcname_with_different_backend_names(self):
        class MYFUNC(FunctionDescr):
            supported_backends = ('postgres', 'mysql', 'sqlite')
            name_mapping = {'postgres': 'MYFUNC',
                            'mysql': 'MYF',
                            'sqlite': 'SQLITE_MYFUNC'}
        auto_register_function(MYFUNC)

        pghelper = get_adv_func_helper('postgres')
        mshelper = get_adv_func_helper('mysql')
        slhelper = get_adv_func_helper('sqlite')
        self.assertEquals(pghelper.func_sqlname('MYFUNC'), 'MYFUNC')
        self.assertEquals(mshelper.func_sqlname('MYFUNC'), 'MYF')
        self.assertEquals(slhelper.func_sqlname('MYFUNC'), 'SQLITE_MYFUNC')


if __name__ == '__main__':
    unittest_main()
