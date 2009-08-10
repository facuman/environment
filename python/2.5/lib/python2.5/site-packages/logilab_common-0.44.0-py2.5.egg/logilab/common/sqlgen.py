"""Help to generate SQL strings usable by the Python DB-API.

:author: Logilab
:copyright: 2000-2008 LOGILAB S.A. (Paris, FRANCE), all rights reserved.
:contact: http://www.logilab.fr/ -- mailto:contact@logilab.fr
:license: General Public License version 2 - http://www.gnu.org/licenses
"""
__docformat__ = "restructuredtext en"

# SQLGenerator ################################################################

class SQLGenerator :
    """
    Helper class to generate SQL strings to use with python's DB-API.
    """

    def where(self, keys, addon=None) :
        """
        :param keys: list of keys

        >>> s = SQLGenerator()
        >>> s.where(['nom'])
        'nom = %(nom)s'
        >>> s.where(['nom','prenom'])
        'nom = %(nom)s AND prenom = %(prenom)s'
        >>> s.where(['nom','prenom'], 'x.id = y.id')
        'x.id = y.id AND nom = %(nom)s AND prenom = %(prenom)s'
        """
        restriction = ["%s = %%(%s)s" % (x, x) for x in keys]
        if addon:
            restriction.insert(0, addon)
        return " AND ".join(restriction)

    def set(self, keys) :
        """
        :param keys: list of keys

        >>> s = SQLGenerator()
        >>> s.set(['nom'])
        'nom = %(nom)s'
        >>> s.set(['nom','prenom'])
        'nom = %(nom)s, prenom = %(prenom)s'
        """
        return ", ".join(["%s = %%(%s)s" % (x, x) for x in keys])

    def insert(self, table, params) :
        """
        :param table: name of the table
        :param params:  dictionnary that will be used as in cursor.execute(sql,params)

        >>> s = SQLGenerator()
        >>> s.insert('test',{'nom':'dupont'})
        'INSERT INTO test ( nom ) VALUES ( %(nom)s )'
        >>> s.insert('test',{'nom':'dupont','prenom':'jean'})
        'INSERT INTO test ( nom, prenom ) VALUES ( %(nom)s, %(prenom)s )'
        """
        keys = ', '.join(params.keys())
        values = ', '.join(["%%(%s)s" % x for x in params])
        sql = 'INSERT INTO %s ( %s ) VALUES ( %s )' % (table, keys, values)
        return sql

    def select(self, table, params) :
        """
        :param table: name of the table
        :param params:  dictionnary that will be used as in cursor.execute(sql,params)

        >>> s = SQLGenerator()
        >>> s.select('test',{})
        'SELECT * FROM test'
        >>> s.select('test',{'nom':'dupont'})
        'SELECT * FROM test WHERE nom = %(nom)s'
        >>> s.select('test',{'nom':'dupont','prenom':'jean'})
        'SELECT * FROM test WHERE nom = %(nom)s AND prenom = %(prenom)s'
        """
        sql = 'SELECT * FROM %s' % table
        where = self.where(params.keys())
        if where :
            sql = sql + ' WHERE %s' % where
        return sql

    def adv_select(self, model, tables, params, joins=None) :
        """
        :param model:  list of columns to select
        :param tables: list of tables used in from
        :param params: dictionnary that will be used as in cursor.execute(sql, params)
        :param joins:  optional list of restriction statements to insert in the
          where clause. Usually used to perform joins.

        >>> s = SQLGenerator()
        >>> s.adv_select(['column'],[('test', 't')], {})
        'SELECT column FROM test AS t'
        >>> s.adv_select(['column'],[('test', 't')], {'nom':'dupont'})
        'SELECT column FROM test AS t WHERE nom = %(nom)s'
        """
        table_names = ["%s AS %s" % (k, v) for k, v in tables]
        sql = 'SELECT %s FROM %s' % (', '.join(model), ', '.join(table_names))
        if joins and type(joins) != type(''):
            joins = ' AND '.join(joins)
        where = self.where(params.keys(), joins)
        if where :
            sql = sql + ' WHERE %s' % where
        return sql

    def delete(self, table, params) :
        """
        :param table: name of the table
        :param params: dictionnary that will be used as in cursor.execute(sql,params)

        >>> s = SQLGenerator()
        >>> s.delete('test',{'nom':'dupont'})
        'DELETE FROM test WHERE nom = %(nom)s'
        >>> s.delete('test',{'nom':'dupont','prenom':'jean'})
        'DELETE FROM test WHERE nom = %(nom)s AND prenom = %(prenom)s'
        """
        where = self.where(params.keys())
        sql = 'DELETE FROM %s WHERE %s' % (table, where)
        return sql

    def update(self, table, params, unique) :
        """
        :param table: name of the table
        :param params: dictionnary that will be used as in cursor.execute(sql,params)

        >>> s = SQLGenerator()
        >>> s.update('test', {'id':'001','nom':'dupont'}, ['id'])
        'UPDATE test SET nom = %(nom)s WHERE id = %(id)s'
        >>> s.update('test',{'id':'001','nom':'dupont','prenom':'jean'},['id'])
        'UPDATE test SET nom = %(nom)s, prenom = %(prenom)s WHERE id = %(id)s'
        """
        where = self.where(unique)
        set = self.set([key for key in params if key not in unique])
        sql = 'UPDATE %s SET %s WHERE %s' % (table, set, where)
        return sql

class BaseTable:
    """
    Another helper class to ease SQL table manipulation.
    """
    # table_name = "default"
    # supported types are s/i/d
    # table_fields = ( ('first_field','s'), )
    # primary_key = 'first_field'

    def __init__(self, table_name, table_fields, primary_key=None):
        if primary_key is None:
            self._primary_key = table_fields[0][0]
        else:
            self._primary_key = primary_key

        self._table_fields = table_fields
        self._table_name = table_name
        info = {
            'key' : self._primary_key,
            'table' : self._table_name,
            'columns' : ",".join( [ f for f,t in self._table_fields ] ),
            'values' : ",".join( [sql_repr(t, "%%(%s)s" % f)
                                  for f,t in self._table_fields] ),
            'updates' : ",".join( ["%s=%s" % (f, sql_repr(t, "%%(%s)s" % f))
                                   for f,t in self._table_fields] ),
            }
        self._insert_stmt = ("INSERT into %(table)s (%(columns)s) "
                             "VALUES (%(values)s) WHERE %(key)s=%%(key)s") % info
        self._update_stmt = ("UPDATE %(table)s SET (%(updates)s) "
                             "VALUES WHERE %(key)s=%%(key)s") % info
        self._select_stmt = ("SELECT %(columns)s FROM %(table)s "
                             "WHERE %(key)s=%%(key)s") % info
        self._delete_stmt = ("DELETE FROM %(table)s "
                             "WHERE %(key)s=%%(key)s") % info

        for k, t in table_fields:
            if hasattr(self, k):
                raise ValueError("Cannot use %s as a table field" % k)
            setattr(self, k,None)


    def as_dict(self):
        d = {}
        for k, t in self._table_fields:
            d[k] = getattr(self, k)
        return d

    def select(self, cursor):
        d = { 'key' : getattr(self,self._primary_key) }
        cursor.execute(self._select_stmt % d)
        rows = cursor.fetchall()
        if len(rows)!=1:
            msg = "Select: ambiguous query returned %d rows"
            raise ValueError(msg % len(rows))
        for (f, t), v in zip(self._table_fields, rows[0]):
            setattr(self, f, v)

    def update(self, cursor):
        d = self.as_dict()
        cursor.execute(self._update_stmt % d)

    def delete(self, cursor):
        d = { 'key' : getattr(self,self._primary_key) }


# Helper functions #############################################################

def name_fields(cursor, records) :
    """
    Take a cursor and a list of records fetched with that cursor, then return a
    list of dictionnaries (one for each record) whose keys are column names and
    values are records' values.

    :param cursor: cursor used to execute the query
    :param records: list returned by fetch*()
    """
    result = []
    for record in records :
        record_dict = {}
        for i in range(len(record)) :
            record_dict[cursor.description[i][0]] = record[i]
        result.append(record_dict)
    return result

def sql_repr(type, val):
    if type == 's':
        return "'%s'" % (val,)
    else:
        return val


if __name__ == "__main__":
    import doctest
    from logilab.common import sqlgen
    print doctest.testmod(sqlgen)
