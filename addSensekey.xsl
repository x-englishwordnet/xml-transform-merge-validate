<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes" />

	<xsl:template match="/">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="Sense">
		<xsl:variable name="senseidx">
			<xsl:number />
		</xsl:variable>
		<xsl:variable name="sensekey">
			<xsl:call-template name="make-sensekey">
				<xsl:with-param name="sensenode" select="." />
				<xsl:with-param name="senseidx" select="$senseidx" />
				<xsl:with-param name="pos" select="../Lemma/@partOfSpeech" />
				<xsl:with-param name="lexfile" select="id(./@synset)/@dc:subject" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:copy>
			<xsl:attribute name="senseidx">
					<xsl:value-of select="format-number($senseidx - 1,'00')" />
			</xsl:attribute>
			<xsl:attribute name="sensekey">
					<xsl:value-of select="$sensekey" />
			</xsl:attribute>
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates select="./SenseRelation" />
			<xsl:apply-templates select="./Example" />
			<xsl:apply-templates select="./Count" />
		</xsl:copy>
	</xsl:template>

	<xsl:template name="make-sensekey">
		<xsl:param name="sensenode" />
		<xsl:param name="senseidx" />
		<xsl:param name="pos" />
		<xsl:param name="lexfile" />

		<!-- LEMMA -->
		<xsl:variable name="lemma">
			<xsl:value-of select="translate($sensenode/../Lemma/@writtenForm,' ABCDEFGHIJKLMNOPQRSTUVWXYZ','_abcdefghijklmnopqrstuvwxyz')" />
		</xsl:variable>

		<!-- LEX_SENSE -->
		<!-- LEX_SENSE.SSTYPE, assumed stable : we do not jump over the part-of-speech boundary, can be computed from $pos /> -->
		<xsl:variable name="sstype">
			<xsl:choose>
				<xsl:when test="$pos = 'n'">
					<xsl:value-of select="1" />
				</xsl:when>
				<xsl:when test="$pos = 'v'">
					<xsl:value-of select="2" />
				</xsl:when>
				<xsl:when test="$pos = 'a'">
					<xsl:value-of select="3" />
				</xsl:when>
				<xsl:when test="$pos = 'r'">
					<xsl:value-of select="4" />
				</xsl:when>
				<xsl:when test="$pos = 's'">
					<xsl:value-of select="5" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$pos" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- LEX_SENSE.LEXFILENUM, assumed stable relative to wn31 : we do not jump over the lexicographer file boundary , can be computed from dc:subject /> -->
		<xsl:variable name="lexfilenum">
			<xsl:choose>
				<xsl:when test="$lexfile = 'adj.all' ">
					<xsl:value-of select="00" />
				</xsl:when>
				<xsl:when test="$lexfile = 'adj.pert' ">
					<xsl:value-of select="01" />
				</xsl:when>
				<xsl:when test="$lexfile = 'adv.all' ">
					<xsl:value-of select="02" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.Tops' ">
					<xsl:value-of select="03" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.act' ">
					<xsl:value-of select="04" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.animal' ">
					<xsl:value-of select="05" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.artifact' ">
					<xsl:value-of select="06" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.attribute' ">
					<xsl:value-of select="07" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.body' ">
					<xsl:value-of select="08" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.cognition' ">
					<xsl:value-of select="09" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.communication' ">
					<xsl:value-of select="10" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.event' ">
					<xsl:value-of select="11" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.feeling' ">
					<xsl:value-of select="12" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.food' ">
					<xsl:value-of select="13" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.group' ">
					<xsl:value-of select="14" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.location' ">
					<xsl:value-of select="15" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.motive' ">
					<xsl:value-of select="16" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.object' ">
					<xsl:value-of select="17" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.person' ">
					<xsl:value-of select="18" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.phenomenon' ">
					<xsl:value-of select="19" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.plant' ">
					<xsl:value-of select="20" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.possession' ">
					<xsl:value-of select="21" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.process' ">
					<xsl:value-of select="22" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.quantity' ">
					<xsl:value-of select="23" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.relation' ">
					<xsl:value-of select="24" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.shape' ">
					<xsl:value-of select="25" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.state' ">
					<xsl:value-of select="26" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.substance' ">
					<xsl:value-of select="27" />
				</xsl:when>
				<xsl:when test="$lexfile = 'noun.time' ">
					<xsl:value-of select="28" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.body' ">
					<xsl:value-of select="29" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.change' ">
					<xsl:value-of select="30" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.cognition' ">
					<xsl:value-of select="31" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.communication' ">
					<xsl:value-of select="32" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.competition' ">
					<xsl:value-of select="33" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.consumption' ">
					<xsl:value-of select="34" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.contact' ">
					<xsl:value-of select="35" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.creation' ">
					<xsl:value-of select="36" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.emotion' ">
					<xsl:value-of select="37" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.motion' ">
					<xsl:value-of select="38" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.perception' ">
					<xsl:value-of select="39" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.possession' ">
					<xsl:value-of select="40" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.social' ">
					<xsl:value-of select="41" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.stative' ">
					<xsl:value-of select="42" />
				</xsl:when>
				<xsl:when test="$lexfile = 'verb.weather' ">
					<xsl:value-of select="43" />
				</xsl:when>
				<xsl:when test="$lexfile = 'adj.ppl' ">
					<xsl:value-of select="44" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('???',$lexfile)" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- LEX_SENSE.LEXID, assume: volatile /> -->
		<xsl:variable name="lexid">
			<xsl:value-of select="format-number($senseidx - 1,'00')" />
		</xsl:variable>

		<!-- SATELLITE HEAD -->
		<xsl:choose>
			<xsl:when test="$pos != 's'">
				<xsl:value-of select="concat($lemma,'%',$sstype,':',format-number($lexfilenum,'00'),':',$lexid,'::')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="head_synset_id">
					<xsl:value-of select="id($sensenode/@synset)/SynsetRelation[@relType='similar']/@target" />
				</xsl:variable>
				<xsl:variable name="first_sense_head_synset_id">
					<xsl:value-of select="//Sense[@synset=$head_synset_id]/@id" />
				</xsl:variable>
				<!-- HEAD WORD : assume: volatile = "the lemma of the first word of the satellite's head synset" /> -->
				<xsl:variable name="headword">
					<xsl:value-of select="translate(id($first_sense_head_synset_id)/../Lemma/@writtenForm,' ','_')" />
				</xsl:variable>

				<!-- HEAD assume: volatile = "a two digit decimal integer that, when appended onto head_word, uniquely identifies the sense of head_word within a lexicographer 
					file, as described for lex_id" /> -->
				<xsl:variable name="headid">
					<xsl:value-of select="format-number(id($first_sense_head_synset_id)/@n,'00')" />
				</xsl:variable>

				<xsl:value-of select="concat($lemma,'%',$sstype,':',format-number($lexfilenum,'00'),':',$lexid,':',$headword,':',$headid)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<!-- <xsl:template match="text()"> <xsl:value-of select="normalize-space()" /> </xsl:template> -->

</xsl:transform>
