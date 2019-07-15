<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<xsl:strip-space elements="*" />
	<xsl:output method="text" indent="no" />

	<xsl:template match="/">
		<xsl:apply-templates select="//Sense" />
	</xsl:template>

	<xsl:template match="Sense">
		<xsl:if test="./@dc:identifier !='' and substring-after(./@sensekey,'%') != substring-after(./@dc:identifier,'%')">
			<xsl:text>---</xsl:text>
			<xsl:value-of select="./@dc:identifier" />
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>+++</xsl:text>
			<xsl:value-of select="./@sensekey" />
			<xsl:text>&#xa;&#xa;</xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:transform>
