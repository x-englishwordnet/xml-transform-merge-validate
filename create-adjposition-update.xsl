<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes" />

	<xsl:template match="/">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="ROW">
		<xsl:variable name="norm_lemma" select="translate(lemma,' ','_')" />
		<xsl:variable name="senseid" select="concat('ewn-',$norm_lemma,'-',position,'-',pos,'-',synsetid)" />
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
			<xsl:element name="senseid">
				<xsl:value-of select="$senseid" />
			</xsl:element>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

</xsl:transform>
