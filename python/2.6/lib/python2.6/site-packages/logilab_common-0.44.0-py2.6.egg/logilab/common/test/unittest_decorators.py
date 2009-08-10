"""unit tests for the decorators module
"""

from logilab.common.testlib import TestCase, unittest_main
from logilab.common.decorators import monkeypatch

class DecoratorsTC(TestCase):

    def test_monkeypatch_with_same_name(self):
        class MyClass: pass
        @monkeypatch(MyClass)
        def meth1(self):
            return 12
        self.assertEquals([attr for attr in dir(MyClass) if attr[:2] != '__'],
                          ['meth1'])
        inst = MyClass()
        self.assertEquals(inst.meth1(), 12)

    def test_monkeypatch_with_custom_name(self):
        class MyClass: pass
        @monkeypatch(MyClass, 'foo')
        def meth2(self, param):
            return param + 12
        self.assertEquals([attr for attr in dir(MyClass) if attr[:2] != '__'],
                          ['foo'])
        inst = MyClass()
        self.assertEquals(inst.foo(4), 16)


if __name__ == '__main__':
    unittest_main()
