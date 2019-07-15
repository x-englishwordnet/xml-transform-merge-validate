<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:import href='lib-sensekey.xsl' />
	<xsl:import href='lib-lexid.xsl' />

	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes" />

	<xsl:variable name="lexid_method" select="'idx'" />

	<xsl:template match="/">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="Sense">

		<xsl:variable name="senseidx">
			<xsl:number />
		</xsl:variable>

		<xsl:variable name="lexid">
			<xsl:call-template name='make-lexid'>
				<xsl:with-param name='sensenode' select='.' />
				<xsl:with-param name='method' select='$lexid_method' />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="sensekey">
			<xsl:call-template name="make-sensekey">
				<xsl:with-param name="sensenode" select="." />
				<xsl:with-param name="method" select="$lexid_method" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:copy>
			<xsl:attribute name="senseidx">
					<xsl:value-of select="format-number($senseidx - 1,'00')" />
			</xsl:attribute>

			<xsl:attribute name="lexid">
					<xsl:value-of select="format-number($lexid,'00')" />
			</xsl:attribute>

			<xsl:attribute name="sensekey">
					<xsl:value-of select="$sensekey" />
			</xsl:attribute>
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates select="./SenseRelation" />
			<xsl:apply-templates select="./Example" />
			<xsl:apply-templates select="./Count" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

</xsl:transform>
