<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="https://globalwordnet.github.io/schemas/dc/">

	<xsl:strip-space elements="*" />
	<xsl:output method="text" indent="no" />

	<xsl:variable name='debug' select='false()' />

	<xsl:template match="/">
		<xsl:variable name="items" select="//Sense[@verbTemplates != '']" />
		<xsl:message>
			<xsl:value-of select="count($items)" />
			<xsl:text> processed</xsl:text>
		</xsl:message>
		<xsl:apply-templates select="$items" />
	</xsl:template>

	<xsl:template match="Sense">
		<xsl:if test="$debug=true()">
			<xsl:message>
				<xsl:text>sensekey </xsl:text>
				<xsl:value-of select="@sensekey" />
				<xsl:text> template=</xsl:text>
				<xsl:value-of select="translate(normalize-space(translate(@verbTemplates,'oewn-st-','')),' ',',')" />
			</xsl:message>
		</xsl:if>
	
		<xsl:value-of select="@sensekey" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="translate(normalize-space(translate(@verbTemplates,'oewn-st-','')),' ',',')" />
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>

</xsl:transform>
