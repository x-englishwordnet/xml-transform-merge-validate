<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<xsl:strip-space elements="*" />
	<xsl:output method="text" indent="yes" />

	<xsl:template match="/">
		<xsl:apply-templates select="//Sense[@dc:identifier='unpolluted%5:00:00:pure:02']" />
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>

	<xsl:template match="Sense">
		<xsl:text>&#xa;</xsl:text>
		<!-- <xsl:text>&#xa;sense idx in lexical entry </xsl:text> <xsl:value-of select="format-number($senseidx - 1,'00')" /> <xsl:variable name="senseidx"> <xsl:number 
			/> </xsl:variable> -->
		<xsl:text>&#xa;legacy sensekey </xsl:text>
		<xsl:value-of select="./@dc:identifier" />

		<xsl:variable name="legacy_satellite">
			<xsl:value-of select="substring-after(substring-after(substring-after(substring-after(./@dc:identifier,'%'),':'),':'),':')" />
		</xsl:variable>

		<xsl:variable name="satellite">
			<xsl:call-template name="make-satellite">
				<xsl:with-param name="sensenode" select="." />
				<xsl:with-param name="pos" select="../Lemma/@partOfSpeech" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:text>&#xa;legacy satellite </xsl:text>
		<xsl:value-of select="$legacy_satellite" />
		<xsl:text>&#xa;satellite        </xsl:text>
		<xsl:value-of select="$satellite" />

	</xsl:template>

	<!-- S E N S E K E Y S A T E L L I T E F A C T O R Y -->

	<xsl:template name="make-satellite">
		<xsl:param name="sensenode" />
		<xsl:param name="pos" />

		<!-- SATELLITE HEAD -->
		<xsl:choose>
			<xsl:when test="$pos != 's'">
				<xsl:value-of select="':'" />
			</xsl:when>

			<xsl:otherwise>
				<xsl:variable name="synset_id" select="$sensenode[1]/@synset" />
				<xsl:variable name="synset" select="id($synset_id)" />
				<xsl:variable name="head_synset_id" select="$synset[1]/SynsetRelation[@relType='similar']/@target" />
				<xsl:variable name="head_senses" select="//Sense[@synset=$head_synset_id]" />
				<xsl:variable name="lemma" select="$head_senses[1]/../Lemma/@writtenForm" />

				<xsl:text>&#xa;*synset_id </xsl:text>
				<xsl:value-of select="$synset_id" />
				<xsl:text>&#xa;*its fetched synset </xsl:text>
				<xsl:value-of select="$synset" />
				<xsl:text>&#xa;*its fetched synset count() </xsl:text>
				<xsl:value-of select="count($synset)" />
				<xsl:text>&#xa;*its fetched synset/@id </xsl:text>
				<xsl:value-of select="$synset/@id" />
				<xsl:text>&#xa;*head_synset_id </xsl:text>
				<xsl:value-of select="$head_synset_id" />
				<xsl:text>&#xa;*head_senses[1].@id </xsl:text>
				<xsl:value-of select="$head_senses[1]/@id" />
				<xsl:text>&#xa;*lemma </xsl:text>
				<xsl:value-of select="$lemma" />
				<xsl:text>&#xa;</xsl:text>
				<!-- -->
				<!-- HEAD WORD : "the lemma of the first word of the satellite's head synset" /> -->
				<xsl:variable name="headword" select="translate($lemma,' ','_')" />

				<!-- HEAD LEXID : "a two digit decimal integer that, when appended onto head_word, uniquely identifies the sense of head_word within a lexicographer file, as 
					described for lex_id" /> -->
				<xsl:variable name="headid">
					<xsl:call-template name="make-lexid-from-idx">
						<xsl:with-param name="sensenode" select="$head_senses[1]" />
					</xsl:call-template>
				</xsl:variable>

				<!-- Value -->
				<xsl:value-of select="concat($headword,':',$headid)" />
				<xsl:value-of select="concat($headword,':',format-number(substring-after($headid, 'RETURN '),'00'))" />
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- based on ordering of 'n' attribute, floored to min value of n -->
	<xsl:template name="make-lexid-from-n">
		<xsl:param name="sensenode" />
		<xsl:variable name="numsenses" select="count($sensenode[1]/parent::LexicalEntry/Sense)" />
		<xsl:text>&#xa;*num senses </xsl:text>
		<xsl:value-of select="$numsenses" />
		<xsl:text>&#xa;</xsl:text>

		<xsl:choose>
			<xsl:when test="$numsenses &gt; 1">
				<xsl:variable name="minn">
					<xsl:for-each select="$sensenode[1]/parent::LexicalEntry/Sense/@n">
						<xsl:sort select="." data-type="number" order="ascending" />
						<xsl:if test="position() = 1">
							<xsl:value-of select="number(.)" />
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="$sensenode[1]/@n - $minn" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="make-lexid-from-idx">
		<xsl:param name="sensenode" />
		<xsl:variable name="senseid" select="$sensenode[1]/@id" />
		<xsl:variable name="allsenses" select="$sensenode[1]/parent::LexicalEntry/Sense" />
		<xsl:variable name="numsenses" select="count($allsenses)" />

		<xsl:text>&#xa;*sense id </xsl:text>
		<xsl:value-of select="$senseid" />
		<xsl:text>&#xa;*num co-senses </xsl:text>
		<xsl:value-of select="$numsenses" />
		<xsl:for-each select="$allsenses">
			<xsl:text>&#xa;*sense </xsl:text>
			<xsl:value-of select="concat('#',position(), ' id=', ./@id, ' synset=', ./@synset)" />
			<xsl:if test='./@id = $senseid'>
				<xsl:text> CHOOSE THIS WITH POSITION </xsl:text>
				<xsl:value-of select="position()" />
			</xsl:if>
		</xsl:for-each>
		<xsl:text>&#xa;RETURN </xsl:text>
		<!-- -->

		<xsl:choose>
			<xsl:when test='$numsenses &gt; 1'>
				<xsl:variable name='senseidx'>
					<xsl:for-each select="$allsenses">
						<xsl:if test='./@id = $senseid'>
							<xsl:value-of select="position()" />
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="$senseidx" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select='0' />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>

</xsl:transform>
