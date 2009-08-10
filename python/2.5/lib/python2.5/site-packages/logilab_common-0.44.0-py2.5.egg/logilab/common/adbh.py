"""Helpers for DBMS specific (advanced or non standard) functionalities.

Helpers are provided for postgresql, mysql and sqlite.

:copyright:
  2000-2009 `LOGILAB S.A. <http://www.logilab.fr>`_ (Paris, FRANCE),
  all rights reserved.

:contact:
  http://www.logilab.org/project/logilab-common --
  mailto:python-projects@logilab.org

:license:
  `General Public License version 2
  <http://www.gnu.org/licenses/old-licenses/gpl-2.0.html>`_
"""
__docformat__ = "restructuredtext en"


class BadQuery(Exception): pass
class UnsupportedFunction(BadQuery): pass


class metafunc(type):
    def __new__(mcs, name, bases, dict):
        dict['name'] = name.upper()
        return type.__new__(mcs, name, bases, dict)


class FunctionDescr(object):
    __metaclass__ = metafunc

    supported_backends = ()
    rtype = None # None <-> returned type should be the same as the first argument
    aggregat = False
    minargs = 1
    maxargs = 1

    name_mapping = {}

    def __init__(self, name=None, rtype=rtype, aggregat=aggregat):
        if name is not None:
            name = name.upper()
        self.name = name
        self.rtype = rtype
        self.aggregat = aggregat

    def backend_name(self, backend):
        return self.name_mapping.get(backend, self.name)
    backend_name = classmethod(backend_name)

    def check_nbargs(cls, nbargs):
        if cls.minargs is not None and \
               nbargs < cls.minargs:
            raise BadQuery('not enough argument for function %s' % cls.name)
        if cls.maxargs is not None and \
               nbargs < cls.maxargs:
            raise BadQuery('too many arguments for function %s' % cls.name)
    check_nbargs = classmethod(check_nbargs)

class AggrFunctionDescr(FunctionDescr):
    aggregat = True
    rtype = None

class MAX(AggrFunctionDescr): pass
class MIN(AggrFunctionDescr): pass
class SUM(AggrFunctionDescr): pass
class COUNT(AggrFunctionDescr):
    rtype = 'Int'
class AVG(AggrFunctionDescr):
    rtype = 'Float'

class UPPER(FunctionDescr):
    rtype = 'String'
class LOWER(FunctionDescr):
    rtype = 'String'
class IN(FunctionDescr):
    """this is actually a 'keyword' function..."""
    maxargs = None
class LENGTH(FunctionDescr):
    rtype = 'Int'

class DATE(FunctionDescr):
    rtype = 'Date'

class RANDOM(FunctionDescr):
    supported_backends = ('postgres', 'mysql',)
    rtype = 'Float'
    minargs = maxargs = 0
    name_mapping = {'postgres': 'RANDOM',
                    'mysql': 'RAND',
                    }

class _GenericAdvFuncHelper:
    """Generic helper, trying to provide generic way to implement
    specific functionnalities from others DBMS

    An exception is raised when the functionality is not emulatable
    """
    # DBMS resources descriptors and accessors

    backend_name = None # overriden in subclasses ('postgres', 'sqlite', etc.)
    needs_from_clause = False
    union_parentheses_support = True
    intersect_all_support = True
    users_support = True
    groups_support = True
    ilike_support = True
    alter_column_support = True
    case_sensitive = False

    FUNCTIONS = {
        # aggregat functions
        'MIN': MIN, 'MAX': MAX,
        'SUM': SUM,
        'COUNT': COUNT,
        'AVG': AVG,
        # transformation functions
        'UPPER': UPPER, 'LOWER': LOWER,
        'LENGTH': LENGTH,
        'DATE': DATE,
        'RANDOM': RANDOM,
        # keyword function
        'IN': IN
        }

    TYPE_MAPPING = {
        'String' :   'text',
        'Int' :      'integer',
        'Float' :    'float',
        'Decimal' :  'decimal',
        'Boolean' :  'boolean',
        'Date' :     'date',
        'Time' :     'time',
        'Datetime' : 'timestamp',
        'Interval' : 'interval',
        'Password' : 'bytea',
        'Bytes' :    'bytea',
        }


    #@classmethod
    def register_function(cls, funcdef):
        if isinstance(funcdef, basestring) :
            funcdef = FunctionDescr(funcdef.upper())
        assert not funcdef.name in cls.FUNCTIONS, \
               '%s is already registered' % funcdef.name
        cls.FUNCTIONS[funcdef.name] = funcdef
    register_function = classmethod(register_function)

    #@classmethod
    def function_description(cls, funcname):
        """return the description (`FunctionDescription`) for a RQL function"""
        try:
            return cls.FUNCTIONS[funcname.upper()]
        except KeyError:
            raise UnsupportedFunction(funcname)
    function_description = classmethod(function_description)

    def func_sqlname(self, funcname):
        funcdef = self.function_description(funcname)
        return funcdef.backend_name(self.backend_name)

    def system_database(self):
        """return the system database for the given driver"""
        raise NotImplementedError('not supported by this DBMS')

    def backup_command(self, dbname, dbhost, dbuser, dbpassword, backupfile,
                       keepownership=True):
        """return a command to backup the given database"""
        raise NotImplementedError('not supported by this DBMS')

    def restore_commands(self, dbname, dbhost, dbuser, backupfile,
                         encoding='utf-8', keepownership=True, drop=True):
        """return a list of commands to restore a backup the given database"""
        raise NotImplementedError('not supported by this DBMS')

    # helpers to standardize SQL according to the database

    def sql_current_date(self):
        return 'CURRENT_DATE'

    def sql_current_time(self):
        return 'CURRENT_TIME'

    def sql_current_timestamp(self):
        return 'CURRENT_TIMESTAMP'

    def sql_create_sequence(self, seq_name):
        return '''CREATE TABLE %s (last INTEGER);
INSERT INTO %s VALUES (0);''' % (seq_name, seq_name)

    def sql_create_index(self, table, column, unique=False):
        idx = self._index_name(table, column, unique)
        if unique:
            return 'ALTER TABLE %s ADD UNIQUE(%s)' % (table, column)
        else:
            return 'CREATE INDEX %s ON %s(%s);' % (idx, table, column)

    def sql_drop_index(self, table, column, unique=False):
        idx = self._index_name(table, column, unique)
        if unique:
            return 'ALTER TABLE %s DROP CONSTRAINT %s' % (table, idx)
        else:
            return 'DROP INDEX %s' % idx

    def sql_drop_sequence(self, seq_name):
        return 'DROP TABLE %s;' % seq_name

    def sqls_increment_sequence(self, seq_name):
        return ('UPDATE %s SET last=last+1;' % seq_name,
                'SELECT last FROM %s;' % seq_name)

    def sql_change_col_type(self, table, column, coltype, null_allowed):
        return 'ALTER TABLE %s ALTER COLUMN %s TYPE %s' % (
            table, column, coltype)

    def sql_set_null_allowed(self, table, column, coltype, null_allowed):
        cmd = null_allowed and 'DROP' or 'SET'
        return 'ALTER TABLE %s ALTER COLUMN %s %s NOT NULL' % (
            table, column, cmd)

    def sql_temporary_table(self, table_name, table_schema,
                            drop_on_commit=True):
        return "CREATE TEMPORARY TABLE %s (%s);" % (table_name, table_schema)

    def boolean_value(self, value):
        if value:
            return 'TRUE'
        else:
            return 'FALSE'

    def increment_sequence(self, cursor, seq_name):
        for sql in self.sqls_increment_sequence(seq_name):
            cursor.execute(sql)
        return cursor.fetchone()[0]

    def create_user(self, cursor, user, password):
        """create a new database user"""
        if not self.users_support:
            raise NotImplementedError('not supported by this DBMS')
        cursor.execute("CREATE USER %(user)s "
                       "WITH PASSWORD '%(password)s'" % locals())

    def _index_name(self, table, column, unique=False):
        if unique:
            # note: this naming is consistent with indices automatically
            # created by postgres when UNIQUE appears in a table schema
            return '%s_%s_key' % (table.lower(), column.lower())
        else:
            return '%s_%s_idx' % (table.lower(), column.lower())

    def create_index(self, cursor, table, column, unique=False):
        if not self.index_exists(cursor, table, column, unique):
            cursor.execute(self.sql_create_index(table, column, unique))

    def drop_index(self, cursor, table, column, unique=False):
        if self.index_exists(cursor, table, column, unique):
            cursor.execute(self.sql_drop_index(table, column, unique))

    def index_exists(self, cursor, table, column, unique=False):
        idx = self._index_name(table, column, unique)
        return idx in self.list_indices(cursor, table)

    def user_exists(self, cursor, username):
        """return True if a user with the given username exists"""
        return username in self.list_users(cursor)

    def list_users(self, cursor):
        """return the list of existing database users"""
        raise NotImplementedError('not supported by this DBMS')

    def create_database(self, cursor, dbname, owner=None, encoding='utf-8'):
        """create a new database"""
        raise NotImplementedError('not supported by this DBMS')

    def list_databases(self):
        """return the list of existing databases"""
        raise NotImplementedError('not supported by this DBMS')

    def list_tables(self, cursor):
        """return the list of tables of a database"""
        raise NotImplementedError('not supported by this DBMS')

    def list_indices(self, cursor, table=None):
        """return the list of indices of a database, only for the given table if specified"""
        raise NotImplementedError('not supported by this DBMS')



def pgdbcmd(cmd, dbhost, dbuser):
    cmd = [cmd]
    if dbhost:
        cmd.append('--host=%s' % dbhost)
    if dbuser:
        cmd.append('--username=%s' % dbuser)
    return cmd


class _PGAdvFuncHelper(_GenericAdvFuncHelper):
    """Postgres helper, taking advantage of postgres SEQUENCE support
    """
    backend_name = 'postgres'
    # modifiable but should not be shared
    FUNCTIONS = _GenericAdvFuncHelper.FUNCTIONS.copy()

    def system_database(self):
        """return the system database for the given driver"""
        return 'template1'

    def backup_command(self, dbname, dbhost, dbuser, backupfile,
                       keepownership=True):
        """return a command to backup the given database"""
        cmd = ['pg_dump -Fc']
        if dbhost:
            cmd.append('--host=%s' % dbhost)
        if dbuser:
            cmd.append('--username=%s' % dbuser)
        if not keepownership:
            cmd.append('--no-owner')
        cmd.append('--file=%s' % backupfile)
        cmd.append(dbname)
        return ' '.join(cmd)

    def restore_commands(self, dbname, dbhost, dbuser, backupfile,
                         encoding='utf-8', keepownership=True, drop=True):
        """return a list of commands to restore a backup the given database"""
        cmds = []
        if drop:
            cmd = pgdbcmd('dropdb', dbhost, dbuser)
            cmd.append(dbname)
            cmds.append(' '.join(cmd))
        cmd = pgdbcmd('createdb -T template0 -E %s' % encoding, dbhost, dbuser)
        cmd.append(dbname)
        cmds.append(' '.join(cmd))
        cmd = pgdbcmd('pg_restore -Fc', dbhost, dbuser)
        cmd.append('--dbname %s' % dbname)
        if not keepownership:
            cmd.append('--no-owner')
        cmd.append(backupfile)
        cmds.append(' '.join(cmd))
        return cmds

    def sql_create_sequence(self, seq_name):
        return 'CREATE SEQUENCE %s;' % seq_name

    def sql_drop_sequence(self, seq_name):
        return 'DROP SEQUENCE %s;' % seq_name

    def sqls_increment_sequence(self, seq_name):
        return ("SELECT nextval('%s');" % seq_name,)

    def sql_temporary_table(self, table_name, table_schema,
                            drop_on_commit=True):
        if not drop_on_commit:
            return "CREATE TEMPORARY TABLE %s (%s);" % (table_name,
                                                        table_schema)
        return "CREATE TEMPORARY TABLE %s (%s) ON COMMIT DROP;" % (table_name,
                                                                   table_schema)

    def create_database(self, cursor, dbname, owner=None, encoding='utf-8'):
        """create a new database"""
        sql = "CREATE DATABASE %(dbname)s"
        if owner:
            sql += " WITH OWNER=%(owner)s"
        if encoding:
            sql += " ENCODING='%(encoding)s'"
        cursor.execute(sql % locals())

    def create_language(self, cursor, extlang):
        """postgres specific method to install a procedural language on a database"""
        # make sure plpythonu is not directly in template1
        cursor.execute("SELECT * FROM pg_language WHERE lanname='%s';" % extlang)
        if cursor.fetchall():
            print '%s language already installed' % extlang
        else:
            cursor.execute('CREATE LANGUAGE %s' % extlang)
            print '%s language installed' % extlang

    def list_users(self, cursor):
        """return the list of existing database users"""
        cursor.execute("SELECT usename FROM pg_user")
        return [r[0] for r in cursor.fetchall()]

    def list_databases(self, cursor):
        """return the list of existing databases"""
        cursor.execute('SELECT datname FROM pg_database')
        return [r[0] for r in cursor.fetchall()]

    def list_tables(self, cursor):
        """return the list of tables of a database"""
        cursor.execute("SELECT tablename FROM pg_tables")
        return [r[0] for r in cursor.fetchall()]

    def list_indices(self, cursor, table=None):
        """return the list of indices of a database, only for the given table if specified"""
        sql = "SELECT indexname FROM pg_indexes"
        if table:
            sql += " WHERE LOWER(tablename)='%s'" % table.lower()
        cursor.execute(sql)
        return [r[0] for r in cursor.fetchall()]


class _SqliteAdvFuncHelper(_GenericAdvFuncHelper):
    """Generic helper, trying to provide generic way to implement
    specific functionnalities from others DBMS

    An exception is raised when the functionality is not emulatable
    """
    backend_name = 'sqlite'
    # modifiable but should not be shared
    FUNCTIONS = _GenericAdvFuncHelper.FUNCTIONS.copy()
    FUNCTIONS.pop('RANDOM') # not defined in sqlite

    users_support = groups_support = False
    ilike_support = False
    union_parentheses_support = False
    intersect_all_support = False
    alter_column_support = False

    def backup_command(self, dbname, dbhost, dbuser, backupfile,
                       keepownership=True):
        """return a command to backup the given database"""
        return 'gzip --stdout %s > %s' % (dbname, backupfile)

    def restore_commands(self, dbname, dbhost, dbuser, backupfile,
                         encoding='utf-8', keepownership=True, drop=True):
        """return a list of commands to restore a backup the given database"""
        return ['gunzip --stdout %s > %s' % (backupfile, dbname)]

    def sql_create_index(self, table, column, unique=False):
        idx = self._index_name(table, column, unique)
        if unique:
            return 'CREATE UNIQUE INDEX %s ON %s(%s);' % (idx, table, column)
        else:
            return 'CREATE INDEX %s ON %s(%s);' % (idx, table, column)

    def sql_drop_index(self, table, column, unique=False):
        return 'DROP INDEX %s' % self._index_name(table, column, unique)

    def list_tables(self, cursor):
        """return the list of tables of a database"""
        # filter type='table' else we get indices as well
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
        return [r[0] for r in cursor.fetchall()]

    def list_indices(self, cursor, table=None):
        """return the list of indices of a database, only for the given table if specified"""
        sql = "SELECT name FROM sqlite_master WHERE type='index'"
        if table:
            sql += " AND LOWER(tbl_name)='%s'" % table.lower()
        cursor.execute(sql)
        return [r[0] for r in cursor.fetchall()]


class _MyAdvFuncHelper(_GenericAdvFuncHelper):
    """MySQL helper, taking advantage of postgres SEQUENCE support
    """
    backend_name = 'mysql'
    needs_from_clause = True
    ilike_support = False # insensitive search by default
    case_sensitive = True

    # modifiable but should not be shared
    FUNCTIONS = _GenericAdvFuncHelper.FUNCTIONS.copy()
    TYPE_MAPPING = _GenericAdvFuncHelper.TYPE_MAPPING.copy()
    TYPE_MAPPING['Password'] = 'tinyblob'
    TYPE_MAPPING['String'] = 'mediumtext'
    TYPE_MAPPING['Bytes'] = 'longblob'
    # don't use timestamp which is automatically updated on row update
    TYPE_MAPPING['Datetime'] = 'datetime'

    def system_database(self):
        """return the system database for the given driver"""
        return ''

    def backup_command(self, dbname, dbhost, dbuser, backupfile,
                       keepownership=True):
        """return a command to backup the given database"""
        # XXX compress
        if dbhost is not None:
            host_option = '-h %s' % dbhost
        else:
            host_option = ''
        return 'mysqldump %s -u %s -p -r %s %s' % (host_option, dbuser,
                                                   backupfile, dbname)

    def restore_commands(self, dbname, dbhost, dbuser, backupfile,
                         encoding='utf-8', keepownership=True, drop=True):
        """return a list of commands to restore a backup the given database"""
        cmds = []
        host_option = ''
        if dbhost is not None:
            host_option = '-h %s' % dbhost
        if drop:
            cmd = 'echo "DROP DATABASE %s;" | mysql %s -u %s -p' % (
                dbname, host_option, dbuser)
            cmds.append(cmd)
        cmd = 'echo "%s;" | mysql %s -u %s -p' % (
            self.sql_create_database(dbname, encoding), host_option, dbuser)
        cmds.append(cmd)
        cmd = 'mysql %s -u %s -p %s < %s' % (host_option, dbuser, dbname, backupfile)
        cmds.append(cmd)
        return cmds

    def sql_temporary_table(self, table_name, table_schema,
                            drop_on_commit=True):
        if not drop_on_commit:
            return "CREATE TEMPORARY TABLE %s (%s);" % (
                table_name, table_schema)
        return "CREATE TEMPORARY TABLE %s (%s) ON COMMIT DROP;" % (
            table_name, table_schema)

    def sql_create_database(self, dbname, encoding='utf-8'):
        sql = "CREATE DATABASE %(dbname)s"
        if encoding:
            sql += " CHARACTER SET %(encoding)s"
        return sql % locals()

    def sql_change_col_type(self, table, column, coltype, null_allowed):
        if null_allowed:
            cmd = 'DEFAULT'
        else:
            cmd = 'NOT'
        return 'ALTER TABLE %s MODIFY COLUMN %s %s NULL' % (
            table, column, coltype, cmd)

    def sql_set_null_allowed(self, table, column, coltype, null_allowed):
        return self.sql_change_col_type(table, column, coltype, null_allowed)

    def create_database(self, cursor, dbname, owner=None, encoding='utf-8'):
        """create a new database"""
        cursor.execute(self.sql_create_database(dbname, encoding))
        if owner:
            cursor.execute('GRANT ALL ON `%s`.* to %s' % (dbname, owner))

    def boolean_value(self, value):
        if value:
            return 1
        else:
            return 0

    def list_users(self, cursor):
        """return the list of existing database users"""
        # Host, Password
        cursor.execute("SELECT User FROM mysql.user")
        return [r[0] for r in cursor.fetchall()]

    def list_databases(self, cursor):
        """return the list of existing databases"""
        cursor.execute('SHOW DATABASES')
        return [r[0] for r in cursor.fetchall()]

    def list_tables(self, cursor):
        """return the list of tables of a database"""
        cursor.execute("SHOW TABLES")
        return [r[0] for r in cursor.fetchall()]

    def list_indices(self, cursor, table=None):
        """return the list of indices of a database, only for the given table if specified"""
        if table:
            cursor.execute("SHOW INDEX FROM %s" % table)
            return [r[2] for r in cursor.fetchall()]
        allindices = []
        for table in self.list_tables(cursor):
            allindices += self.list_indices(cursor, table)
        return allindices



ADV_FUNC_HELPER_DIRECTORY = {'postgres': _PGAdvFuncHelper(),
                             'sqlite': _SqliteAdvFuncHelper(),
                             'mysql': _MyAdvFuncHelper(),
                             }



def get_adv_func_helper(driver):
    """returns an advanced function helper for the given driver"""
    return ADV_FUNC_HELPER_DIRECTORY[driver]

def register_function(driver, funcdef):
    ADV_FUNC_HELPER_DIRECTORY[driver].register_function(funcdef)

# this function should be called `register_function` but the other
# definition was defined prior to this one
def auto_register_function(funcdef):
    """register the function `funcdef` on supported backends"""
    for driver in  funcdef.supported_backends:
        register_function(driver, funcdef)
