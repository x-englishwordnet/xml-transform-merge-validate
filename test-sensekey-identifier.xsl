<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:import href='lib-diff.xsl' />

	<xsl:strip-space elements="*" />
	<xsl:output method="text" indent="no" />

	<xsl:template match="/">
		<xsl:variable name="diff_scope" select="//Sense[string(@sensekey) != string(@dc:identifier)]" />
		<xsl:for-each select="$diff_scope">
			<xsl:call-template name="sense-node-diff">
				<xsl:with-param name="var1" select="string(@dc:identifier)" />
				<xsl:with-param name="var2" select="string(@sensekey)" />
			</xsl:call-template>
		</xsl:for-each>
		<xsl:value-of select="count($diff_scope)" />
		<xsl:text> diffs&#xa;</xsl:text>
	</xsl:template>

</xsl:transform>
