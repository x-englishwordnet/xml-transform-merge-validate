#!/bin/bash

FROMDIR=in/lexfiles
TODIR=out/lexfiles2

adj="
wn-adj.all.xml
wn-adj.pert.xml
wn-adj.ppl.xml
"

adv="
wn-adv.all.xml
"

noun="
wn-noun.act.xml
wn-noun.animal.xml
wn-noun.artifact.xml
wn-noun.attribute.xml
wn-noun.body.xml
wn-noun.cognition.xml
wn-noun.communication.xml
wn-noun.event.xml
wn-noun.feeling.xml
wn-noun.food.xml
wn-noun.group.xml
wn-noun.location.xml
wn-noun.motive.xml
wn-noun.object.xml
wn-noun.person.xml
wn-noun.phenomenon.xml
wn-noun.plant.xml
wn-noun.possession.xml
wn-noun.process.xml
wn-noun.quantity.xml
wn-noun.relation.xml
wn-noun.shape.xml
wn-noun.state.xml
wn-noun.substance.xml
wn-noun.time.xml
wn-noun.Tops.xml
"

verb="
wn-verb.body.xml
wn-verb.change.xml
wn-verb.cognition.xml
wn-verb.communication.xml
wn-verb.competition.xml
wn-verb.consumption.xml
wn-verb.contact.xml
wn-verb.creation.xml
wn-verb.emotion.xml
wn-verb.motion.xml
wn-verb.perception.xml
wn-verb.possession.xml
wn-verb.social.xml
wn-verb.stative.xml
wn-verb.weather.xml
"

mkdir -p $TODIR

for f in $verb ; do
	echo "PIP: $f (v)" 1>&2;
	./pipeline-verb.sh $FROMDIR/$f > $TODIR/$f
done

for f in $noun $adj $adv ; do
	echo "PIP: $f" 1>&2;
	./pipeline.sh $FROMDIR/$f > $TODIR/$f
done

