<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:output omit-xml-declaration="no" standalone="no" method="xml" version="1.1" encoding="UTF-8" indent="yes" />
	<!-- doctype-system="http://globalwordnet.github.io/schemas/WN-LMF-relaxed-1.2.dtd" -->
	<xsl:strip-space elements="*" />

	<xsl:param name="updateFileName" select="'adjpositions-update.xml'" />
	<xsl:param name="updates" select="document($updateFileName)" />

	<xsl:variable name='debug' select='false()' />

	<xsl:template match="/">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="LexicalResource">
		<LexicalResource 
			xmlns:dc="http://purl.org/dc/elements/1.1/" 
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation=". https://1313ou.github.io/ewn-validation/WN-LMF-1.6-relax_idrefs.xsd">
			<xsl:apply-templates select="./*" />
		</LexicalResource>
	</xsl:template>

	<xsl:template match="Sense">
		<xsl:variable name="senseid" select="@id" />
		<xsl:variable name="lemma" select="translate(../Lemma/@writtenForm,' ','_')" />
		<xsl:variable name="synsetid" select="substring-before(substring-after(@synset,'ewn-'),'-')" />
		<xsl:variable name="pos" select="../Lemma/@partOfSpeech" />
		<xsl:variable name="row" select="$updates/DATA/ROW[starts-with($senseid,senseid)]" />
		<xsl:variable name="adjposition" select="$row/position" />

		<xsl:if test="$adjposition">
			<xsl:message>
				<xsl:text> senseid=</xsl:text>
				<xsl:value-of select="$senseid" />
				<xsl:text> lemma=</xsl:text>
				<xsl:value-of select="$lemma" />
				<xsl:text> synsetid=</xsl:text>
				<xsl:value-of select="$synsetid" />
				<xsl:text> pos=</xsl:text>
				<xsl:value-of select="$pos" />
				<xsl:text> - position=</xsl:text>
				<xsl:value-of select="$adjposition" />
			</xsl:message>
		</xsl:if>

		<xsl:copy>
			<xsl:if test="$adjposition">
				<xsl:attribute name="adj_position">
					<xsl:value-of select="$adjposition" />
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

</xsl:transform>
