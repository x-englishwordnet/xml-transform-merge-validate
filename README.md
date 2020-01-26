# ewn-transformation
XML transformation of English Wordnet lexical files

The XSLT transformer that performs transformation on files.

*Needed:*

* java runtime >= 8

* transform.sh

* transformer.jar

* <transformation>.xsl


**How to run:**

```
*To stdout:*
./transform.sh <transformation>.xsl - infile [infile]\*
*To file:*
./transform.sh <transformation>.xsl out.xml infile [infile]\*
*To dir:*
./transform.sh <transformation>.xsl outdir -dir infile [infile]*
```

**Pipeline**

The transformations can be pipelined using '-' as input/output.


**XSL files:**

|pos    | xsl                       | dependency   | dependency     | dependency |
|------ | ------------------------- | ------------ | -------------- | ---------- |
|n,v,a,r| add-sensekekey            |              |                |            |
|n,v,a,r|                           | lib-lexid    |                |            |
|n,v,a,r|                           | lib-sensekey |                |            |
|n,v,a,r|                           |              | lib-lexid      |            |
|n,v,a,r|                           |              | satellite_head |            |
|n,v,a,r|                           |              |                | lib-lexid  |
|n,v,a,r| add-tag_count             |              |                |            |
|v      | add-verb_frames_entity    |              |                |            |
|v      | add-verb_frames           |              |                |            |
|v      | add-verb_frames-attr      |              |                |            |
|v      | add-verb_templates_entity |              |                |            |
|v      | add-verb_templates        |              |                |            |
|a      | add-adj_position          |              |                |            | 

