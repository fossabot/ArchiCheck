
# Ada units test suite



##  Ada units test suite / Subunits (separate) unit test

  procedure Sub.Test has several separate units :
  - separate procedure
  - separate package
  - separate function
  - separate task
  - separate protected

  > archicheck -ld -I src

  Expected :

```
Sub.Test.Ressource protected body depends on A6 
Enum_IO package spec depends on Ada.Text_IO.Enumeration_IO 
Rational_Numbers package body depends on Rational_Numbers.Reduce 
Sub.Tools package spec depends on A2 
Sub.Test procedure body depends on Rational_IO 
Sub.Test procedure body depends on New_Page 
Sub.Test procedure body depends on Util.New_Page 
Sub.Test.Put procedure body depends on A1 
Rational_Io package spec depends on A4 
Rational_Io package spec depends on Rational_Numbers.IO 
Rational_Numbers.Reduce procedure body depends on A2 
Sub.Test.Server task body depends on A7 
Rational_Numbers.Reduce procedure body depends on A3 
Rational_Numbers package spec depends on A5 
Util.New_Page package spec depends on Interfaces.C 
Sub.Test.Get function body depends on A3 
New_Page procedure spec depends on Text_IO_New_Page 
Rational_Numbers.IO package spec depends on A2 
```


 Ada units test suite / Subunits (separate) unit test [Successful]("tests-status#successful")