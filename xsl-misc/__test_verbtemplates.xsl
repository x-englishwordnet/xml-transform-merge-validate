<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:strip-space elements="*" />
	<xsl:output method="text" indent="no" />

	<xsl:variable name='debug' select='true()' />

	<xsl:template match="/">

		<xsl:variable name="sensekey31">
			<xsl:text>wow%2:37:00::</xsl:text>
		</xsl:variable>
		<xsl:text>sensekey </xsl:text>
		<xsl:value-of select="$sensekey31" />
		<xsl:text> </xsl:text>

		<xsl:for-each select="/DATA/ROW[sensekey31/text() = $sensekey31]/template">
			<xsl:variable name="template" select="." />
			<xsl:text>template </xsl:text>
			<xsl:value-of select="$template" />
			<xsl:text> </xsl:text>
		</xsl:for-each>
		<xsl:text>&#xa;</xsl:text>

	</xsl:template>

</xsl:transform>
