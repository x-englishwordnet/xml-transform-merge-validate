# sensekeys

Source document is [here](https://wordnet.princeton.edu/documentation/senseidx5wn).

*sense_key* is an encoding of the word sense. Programs can construct a sense key in this format and use it as a binary search key into the sense index file.

A sense_key is represented as:

`sensekey := lemma % lex_sense`
		
where

- **lemma** is is the ASCII text of the word or collocation as found in the WordNet database index file corresponding to pos . lemma is in lower case, and collocations are formed by joining individual words with an underscore (_ ) character
- **lex_sense** is encoded as:

`lexsense := ss_type:lex_filenum:lex_id:head_word:head_id`
			
where

- **ss_type** is a one digit decimal integer representing the synset type for the sense. See Synset Type below for a listing of the numbers corresponding to each synset type.

- **lex_filenum** is a two digit decimal integer representing the name of the lexicographer file containing the synset for the sense. See lexnames(5WN) for the list of lexicographer file names and their corresponding numbers.

- **lex_id** is a two digit decimal integer that, when appended onto lemma , uniquely identifies a sense within a lexicographer file. lex_id numbers usually start with 00 , and are incremented as additional senses of the word are added to the same file, although there is no requirement that the numbers be consecutive or begin with 00 . Note that a value of 00 is the default, and therefore is not present in lexicographer files. Only non-default lex_id values must be explicitly assigned in lexicographer files. See wninput(5WN) for information on the format of lexicographer files.

- **head_word** is only present if the sense is in an adjective satellite synset. It is the lemma of the first word of the satellite's head synset.

- **head_id** is a two digit decimal integer that, when appended onto head_word , uniquely identifies the sense of head_word within a lexicographer file, as described for lex_id . There is a value in this field only if head_word is present.


Since the lex_id is lost or may be absent we use

- 00 if there is only one sense for the lexical entry or

- the 1-based index of the Sense within the LexicalEntry if there are more.



lexicographer file|entry    |n|sense                 |lid|sensekey                 |LID|SENSEKEY
------------------|---------|-|----------------------|---|-------------------------|---|-------------------------
verb possession 40|abandon1 |2|forsake,leave behind  |0  |abandon%2:40:00::        | 1 |abandon%2:40:01::
verb.possession 40|abandon  |1|give up ...           |1  |abandon%2:40:01::        | 2 |abandon%2:40:02::
verb.motion 38    |abandon  |3|leave behind empty    |0  |abandon%2:38:00::        | 0 |abandon%2:38:00::
verb.cognition 31 |abandon1 |4|stop maintaining      |1  |abandon%2:31:01::        | 1 |abandon%2:40:01::
verb.cognition 31 |abandon  |5|leave someone         |0  |abandon%2:31:00::        | 2 |abandon%2:40:02::
adj.all 00        |GENEROUS1|1|willing to give       |1  |generous%3:00:01::       | 1 |generous%3:00:01::
adj.all 00        |GENEROUS2|2|not petty in character|2  |generous%3:00:02::       | 2 |generous%3:00:02::
adj.all 00        |generous |3|more than enough      |0  |generous%5:00:00:ample:00| 0 |generous%5:00:00:ample:00

current lex_id and sensekey/PROPOSED LEX_ID and SENSEKEY

# Sample lexicographer files

## verb.possession
2
>{ [ abandon1, noun.act:abandonment3,+ ] give_up, ... (give up with the intent of never claiming again; ...) }

1
>{ [ abandon, noun.act:abandonment2,+ ] discard,@ ... (forsake, leave behind;...) }

## verb.motion
3
>{ [ vacate, adj.all:empty^vacant1,+ ] empty, abandon, leave1,@ ... (leave behind empty; move out of; ...) }

## verb.cognition
4
>{ [ abandon1, noun.act:abandonment3,+ ] give_up, verb.motion:give13,$ verb.motion:give,$ ... (stop maintaining or insisting on; of ideas or claims; ...) }

5
>{ [ abandon, noun.act:abandonment1,+ ] [ forsake, noun.act:forsaking1,+ ] [ desolate, noun.feeling:desolation2,+ ] [ desert, noun.act:desertion,+ noun.person:deserter1,+ noun.person:deserter,+ ] leave5,@ ... (leave someone who needs or counts on you; leave in the lurch; ...) }


## adj.all

1
>[{ [ GENEROUS1, noun.attribute:generousness,+ noun.act:generosity,+ STINGY,!] CHARITABLE,^ GENEROUS2,^ UNSELFISH,^ noun.attribute:generosity,= (willing to give and share unstintingly; ...) }

>{ benevolent, freehearted, (generous in providing aid to others) }

>{ big, [ bighearted, noun.attribute:bigheartedness,+ ] [ bounteous, noun.attribute:bounty1,+ noun.attribute:bounteousness,+ ] [ bountiful, noun.attribute:bountifulness,+ ] freehanded, handsome, giving, [ liberal, noun.attribute:liberalness,+ noun.attribute:liberality,+ ] [ openhanded, noun.attribute:openhandedness,+ ] (given or giving freely; ...) }

>{ [ lavish, noun.attribute:lavishness,+ noun.act:lavishness,+ ] [ munificent, noun.attribute:munificence,+ ] overgenerous, too-generous, unsparing, unstinted, unstinting, (very generous; ...) }

>{ [ unselfish, noun.attribute:unselfishness,+ noun.act:unselfishness,+ ] (not greedy) }

>\-\-\-\-

>{ [ STINGY, noun.attribute:stinginess,+ GENEROUS1,!] ungenerous4, SELFISH,^ UNCHARITABLE,^ UNGENEROUS,^ noun.attribute:generosity,= (unwilling to spend; ...) }
>...

2
>[{ [ GENEROUS2, noun.attribute:generousness,+ noun.attribute:generosity,+ UNGENEROUS,!] GENEROUS1,^ (not petty in character and mind; ...) }

>{ big, large, [ magnanimous, noun.attribute:magnanimousness,+ noun.attribute:magnanimity,+ ] (generous and understanding and tolerant; ...) }

>{ ungrudging, (without envy or reluctance; "ungrudging admiration") }

3
>[{ [ AMPLE, noun.attribute:ampleness1,+ MEAGER,!] ABUNDANT,^ SUFFICIENT,^ noun.attribute:sufficiency,= (more than enough in size or scope or capacity; ...) }
>{ generous, (more than adequate; "a generous portion") }


