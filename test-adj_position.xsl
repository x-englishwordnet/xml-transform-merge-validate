<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:output omit-xml-declaration="no" standalone="no" method="text" version="1.1" encoding="UTF-8" indent="yes" />
	<!-- doctype-system="http://globalwordnet.github.io/schemas/WN-LMF-relaxed-1.2.dtd" -->
	<xsl:strip-space elements="*" />

	<xsl:param name="updateFileName" select="'adjpositions-update.xml'" />
	<xsl:param name="updates" select="document($updateFileName)" />

	<xsl:variable name='debug' select='false()' />

	<xsl:template match="/">
		<xsl:for-each select="$updates/DATA/ROW">
			<!-- <xsl:value-of select="." /> -->
			<xsl:variable name="norm_lemma" select="translate(lemma,' ','_')" />
			<xsl:variable name="senseid" select="senseid" />
			<xsl:variable name="sense" select="//Sense[starts-with(@id,$senseid)]" />

			<xsl:if test="$debug=true()">
				<xsl:message>
					<xsl:number />
					<xsl:text> </xsl:text>
					<xsl:value-of select="$senseid" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="count($sense)" />
				</xsl:message>
			</xsl:if>

			<xsl:if test="count($sense) != 1">
				<xsl:text>failed: </xsl:text>
				<xsl:value-of select="$senseid" />
				<xsl:text>&#xa;</xsl:text>
			</xsl:if>

		</xsl:for-each>
		<xsl:message>
			<xsl:text>count: </xsl:text>
			<xsl:value-of select="count($updates/DATA/ROW)" />
		</xsl:message>
	</xsl:template>

	<xsl:template match="Sense">
		<xsl:variable name="lemma" select="translate(../Lemma/@writtenForm,' ','_')" />
		<xsl:variable name="pos" select="../Lemma/@partOfSpeech" />
		<xsl:variable name="synsetid" select="substring-before(substring-after(@synset,'ewn-'),'-')" />
		<xsl:variable name="row" select="$updates/DATA/ROW[lemma=$lemma and synsetid=$synsetid and pos=$pos]" />
		<xsl:variable name="adjposition" select="@position" />

		<xsl:if test="$adjposition">
			<xsl:message>
				<xsl:text>lemma=</xsl:text>
				<xsl:value-of select="$lemma" />
				<xsl:text> synsetid=</xsl:text>
				<xsl:value-of select="$synsetid" />
				<xsl:text> pos=</xsl:text>
				<xsl:value-of select="$pos" />
				<xsl:text> - position=</xsl:text>
				<xsl:value-of select="$adjposition" />
			</xsl:message>
		</xsl:if>
	</xsl:template>


</xsl:transform>
