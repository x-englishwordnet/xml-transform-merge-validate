<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:strip-space elements="*" />

	<xsl:output omit-xml-declaration="no" standalone="no" method="xml" version="1.1" encoding="UTF-8" indent="yes"
		doctype-system="http://globalwordnet.github.io/schemas/WN-LMF-relaxed-1.2.dtd" />

	<xsl:strip-space elements="*" />

	<xsl:key name='find-syntactic_behaviour-by-frame' match='/LexicalResource/Lexicon/SyntacticBehaviour' use='normalize-space(@subcategorizationFrame)'></xsl:key>

	<xsl:template match="/">
		<xsl:apply-templates select="/LexicalResource/Lexicon/LexicalEntry/SyntacticBehaviour" />
	</xsl:template>

	<xsl:template match="SyntacticBehaviour">
		<xsl:variable name="frame" select="@subcategorizationFrame" />
		<xsl:variable name="sb" select="key('find-syntactic_behaviour-by-frame', $frame)" />
		<xsl:variable name="sbid">
			<xsl:for-each select="$sb">
				<xsl:value-of select="./@id" />
				<xsl:text> </xsl:text>
			</xsl:for-each>
		</xsl:variable>

		<xsl:message>
			<xsl:text>frame </xsl:text>
			<xsl:value-of select="normalize-space($frame)" />
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>sb length </xsl:text>
			<xsl:value-of select="count($sb)" />
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>sbid </xsl:text>
			<xsl:value-of select="$sbid" />
			<xsl:text>&#xa;</xsl:text>
		</xsl:message>

		<xsl:element name="SyntacticBehaviourRef">
			<xsl:attribute name="idref"><xsl:value-of select="normalize-space($sbid)" /></xsl:attribute>
			<xsl:attribute name="senses"><xsl:value-of select="./@senses" /></xsl:attribute>
		</xsl:element>
		<xsl:text>&#xa;</xsl:text>

	</xsl:template>

</xsl:transform>
