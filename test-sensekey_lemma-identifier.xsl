<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:import href='lib-diff.xsl' />

	<xsl:strip-space elements="*" />
	<xsl:output method="text" indent="no" />

	<xsl:template match="/">
		<xsl:apply-templates select="//Sense" />
	</xsl:template>

	<xsl:template match="Sense">
		<xsl:variable name="var0" select="./@dc:identifier" />
		<xsl:variable name="var1" select="substring-before(@sensekey,'%')" />
		<xsl:variable name="var2" select="substring-before(@dc:identifier,'%')" />
				
		<xsl:if test="$var0 !='' and $var1 != $var2">
			<xsl:call-template name="sense-node-diff">
				<xsl:with-param name="var1" select="$var1" />
				<xsl:with-param name="var2" select="$var2" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

</xsl:transform>
