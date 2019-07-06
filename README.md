# ewn-validation
XML validation of English Wordnet

Two XSD's are provided:
-one with IDREF validation (checks that each ID references matches an existing ID, can be VERY long)
-the other without (only checks that each ID is a well-formed NCName)

*Needed:*

* java runtime >= 8

* run.sh

* validator.jar

* WN-LMF-1.0[-relax_idrefs].xsd


*How to run:*

```
./run.sh (-strict) (dir) 
```

dir is by default the current dir
