<p align="center">
<img width="256" height="256" src="images/xewn2.png">
</p>

# XML Tools

These act as preprocessors to [ewn-grind](https://github.com/x-englishwordnet/ewn-grind) and work in a pipeline.


### Transformer

[ewn-transformation](https://github.com/x-englishwordnet/ewn-transformation) 
[ewn-transformation3](https://github.com/x-englishwordnet/ewn-transformation3) 
Transformations are expressed in XSLT 1.0 to make processing __declarative__, __versatile__. Transformations are __pipelined__.

In some cases it is easier to declare transformations in XSLT 3.0. A Woodstox transformer is then used.

Adds attributes to *Sense* elements. See [XML diffs](XML-diffs.md).

Factors out SyntacticBehaviours to avoid redundancy, syntactic behaviours are referenced by an ID list attribute in Sense instead. 

Generates sents.vrb and sentidx.vrb as text files (this is how syntactic behaviours are referenced in WordNet)

Generates a sensemap. Each line maps a sense id to its generated internal sensekey and, if any, its PWN foreign key (dc:identifier).

### Merge tool

[ewn-merging](https://github.com/x-englishwordnet/ewn-merging) 
XSLT merging of lexicographer files.
Merges the XML files into one using XSLT 3.0-conformant Saxon 9.9 powerhouse transformer

### Validator

[ewn-validation](https://github.com/x-englishwordnet/ewn-validation) 
[ewn-validation2](https://github.com/x-englishwordnet/ewn-validation2) 
Validation is based on XSD which permits fine-grained strict type validation.
5 schemas are provided to validate each stage of the pipeline (see below)
Types have been factored out.
Two versions of the schemas are available : one relaxing ID references, to be used with split lexicographer files (some references cross file boundaries, notably derivations), the other that does not (to be used with self-contained merged file) that imposes extra constraints of existence.
