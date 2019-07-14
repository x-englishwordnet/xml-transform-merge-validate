<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:import href = 'lib-satellite_head.xsl' />
	<xsl:strip-space elements="*" />
	<xsl:output method="text" indent="yes" />

	<xsl:variable name='debug' select='true()' />

	<xsl:template match="/">
		<xsl:apply-templates select="//Sense" />
	</xsl:template>

	<xsl:template match="Sense">

		<xsl:variable name="legacy_satellite">
			<xsl:value-of select="substring-after(substring-after(substring-after(substring-after(./@dc:identifier,'%'),':'),':'),':')" />
		</xsl:variable>

		<xsl:variable name="satellite">
			<xsl:call-template name="make-satellite-head">
				<xsl:with-param name="sensenode" select="." />
				<xsl:with-param name="pos" select="../Lemma/@partOfSpeech" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:text>&#xa;legacy sensekey </xsl:text>
		<xsl:value-of select="./@dc:identifier" />
		<xsl:text>&#xa;legacy satellite </xsl:text>
		<xsl:value-of select="$legacy_satellite" />
		<xsl:text>&#xa;satellite        </xsl:text>
		<xsl:value-of select="$satellite" />

		<xsl:text>&#xa;</xsl:text>

	</xsl:template>

</xsl:transform>
