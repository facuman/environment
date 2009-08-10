
from logilab.common.testlib import TestCase, unittest_main

from logilab.common.adbh import get_adv_func_helper


class PGHelperTC(TestCase):
    driver = 'postgres'
    def setUp(self):
        self.helper = get_adv_func_helper(self.driver)

    def test_type_map(self):
        self.assertEquals(self.helper.TYPE_MAPPING['Datetime'], 'timestamp')
        self.assertEquals(self.helper.TYPE_MAPPING['String'], 'text')
        self.assertEquals(self.helper.TYPE_MAPPING['Password'], 'bytea')
        self.assertEquals(self.helper.TYPE_MAPPING['Bytes'], 'bytea')


class SQLITEHelperTC(PGHelperTC):
    driver = 'sqlite'


class MYHelperTC(PGHelperTC):
    driver = 'mysql'

    def test_type_map(self):
        self.assertEquals(self.helper.TYPE_MAPPING['Datetime'], 'datetime')
        self.assertEquals(self.helper.TYPE_MAPPING['String'], 'mediumtext')
        self.assertEquals(self.helper.TYPE_MAPPING['Password'], 'tinyblob')
        self.assertEquals(self.helper.TYPE_MAPPING['Bytes'], 'longblob')


if __name__ == '__main__':
    unittest_main()
