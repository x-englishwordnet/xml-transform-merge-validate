<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:strip-space elements="*" />
	<xsl:output method="text" indent="no" />

	<xsl:template match="/">
		<xsl:variable name="items" select="/LexicalResource/Lexicon/SyntacticBehaviour" />
		<xsl:for-each select="$items">
			<xsl:value-of select="position()" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="@subcategorizationFrame" />
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>

		<xsl:message>
			<xsl:value-of select="count($items)" />
			<xsl:text> processed</xsl:text>
		</xsl:message>
	</xsl:template>

</xsl:transform>
