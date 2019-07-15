<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<xsl:strip-space elements="*" />
	<xsl:output method="text" indent="no" />

	<xsl:template match="/">
		<xsl:text>&#xa;Null @dc:subject in Synset&#xa;</xsl:text>
		<xsl:apply-templates select="//Synset[string(@dc:subject) = '']" />
	</xsl:template>

	<xsl:template match="Synset">
		<xsl:value-of select="position()" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="./@id" />
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>

</xsl:transform>
