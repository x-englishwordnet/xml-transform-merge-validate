<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<xsl:strip-space elements="*" />
	<xsl:output method="text" indent="yes" />

	<xsl:template match="/">
		<xsl:apply-templates select="//Sense" />
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>

	<xsl:template match="Sense">
		<xsl:text>&#xa;</xsl:text>
		<xsl:variable name="senseidx">
			<xsl:number />
		</xsl:variable>
		<xsl:variable name="nth">
			<xsl:value-of select="./@n" />
		</xsl:variable>
		<xsl:variable name="idxlexid">
			<xsl:variable name="numsenses">
				<xsl:value-of select="count(../Sense)" />
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$numsenses &gt; 1">
					<xsl:value-of select="$senseidx" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="0" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="nbasedlexid">
			<xsl:variable name="numsenses">
				<xsl:value-of select="count(../Sense)" />
			</xsl:variable>
			<xsl:variable name="minsense">
				<xsl:for-each select="../Sense/@n">
					<xsl:sort select="." data-type="number" order="ascending" />
					<xsl:if test="position() = 1">
						<xsl:value-of select="number(.)" />
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$numsenses &gt; 1">
					<xsl:value-of select="$nth - $minsense" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="0" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="legacylexid">
			<xsl:value-of select="substring-before(substring-after(substring-after(substring-after(./@dc:identifier,'%'),':'),':'),':')" />
		</xsl:variable>
		<xsl:variable name="sensekey">
			<xsl:call-template name="make-sensekey">
				<xsl:with-param name="sensenode" select="." />
				<xsl:with-param name="lexid" select="$legacylexid" />
				<xsl:with-param name="pos" select="../Lemma/@partOfSpeech" />
				<xsl:with-param name="lexfile" select="id(./@synset)/@dc:subject" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:text>&#xa;sense #</xsl:text>
		<xsl:value-of select="$nth" />

		<xsl:text>&#xa;n </xsl:text>
		<xsl:value-of select="./@n" />

		<xsl:text>&#xa;sense idx in lexical entry </xsl:text>
		<xsl:value-of select="format-number($senseidx - 1,'00')" />

		<xsl:text>&#xa;checked_synset </xsl:text>
		<xsl:value-of select="id(./@synset)/@id" />

		<xsl:text>&#xa;lexfile </xsl:text>
		<xsl:value-of select="id(./@synset)/@dc:subject" />

		<xsl:text>&#xa;legacy lexid </xsl:text>
		<xsl:value-of select="format-number($legacylexid,'00')" />

		<xsl:text>&#xa;idx lexid </xsl:text>
		<xsl:value-of select="format-number($idxlexid,'00')" />

		<xsl:text>&#xa;n-based lexid </xsl:text>
		<xsl:value-of select="format-number($nbasedlexid,'00')" />

		<xsl:text>&#xa;wn sensekey  </xsl:text>
		<xsl:value-of select="./@dc:identifier" />

		<xsl:text>&#xa;ewn sensekey </xsl:text>
		<xsl:value-of select="$sensekey" />

		<xsl:text>&#xa;equals </xsl:text>
		<xsl:value-of select="$sensekey = ./@dc:identifier" />

	</xsl:template>

	<xsl:template name="make-sensekey">
		<xsl:param name="sensenode" />
		<xsl:param name="lexid" />
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

		<!-- SATELLITE HEAD -->
		<xsl:choose>
			<xsl:when test="$pos != 's'">
				<xsl:value-of select="concat($lemma,'%',$sstype,':',format-number($lexfilenum,'00'),':',format-number($lexid,'00'),'::')" />
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

				<xsl:value-of
					select="concat($lemma,'%',format-number($sstype,'0'),':',format-number($lexfilenum,'00'),':',format-number($lexid,'00'),':',$headword,':',$headid)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:transform>
