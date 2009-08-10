# unit tests for the cache module

from logilab.common.testlib import TestCase, unittest_main
from logilab.common.graph import get_cycles

class getCycleTestCase(TestCase):

    def test_known0(self):
        self.assertEqual(get_cycles({1:[2], 2:[3], 3:[1]}), [[1, 2, 3]])

    def test_known1(self):
        self.assertEqual(get_cycles({1:[2], 2:[3], 3:[1, 4], 4:[3]}), [[1, 2, 3], [3, 4]])

    def test_known2(self):
        self.assertEqual(get_cycles({1:[2], 2:[3], 3:[0], 0:[]}), [])


if __name__ == "__main__":
    unittest_main()
