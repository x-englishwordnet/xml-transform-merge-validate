<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="Sense">
		<xsl:variable name="senseidx">
			<xsl:number />
		</xsl:variable>
		<xsl:variable name="sensekey">
			<xsl:call-template name="make-sensekey">
				<xsl:with-param name="sensenode" select="." />
				<xsl:with-param name="senseidx" select="$senseidx" />
				<xsl:with-param name="wn31sensekey" select="./@dc:identifier" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:copy>
			<xsl:attribute name="senseidx">
					<xsl:value-of select="$senseidx -1" />
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

	<xsl:template name="make-sensekey">
		<xsl:param name="sensenode" />
		<xsl:param name="senseidx" />
		<xsl:param name="wn31sensekey" />

		<xsl:variable name="lemma">
			<xsl:value-of select="translate($sensenode/../Lemma/@writtenForm,' ','_')" />
		</xsl:variable>
		<xsl:variable name="wn31lexsense">
			<xsl:value-of select="substring-after($wn31sensekey,'%')" />
		</xsl:variable>
		<xsl:variable name="wn31lexsense_tail1">
			<xsl:value-of select="substring-after($wn31lexsense,':')" />
		</xsl:variable>
		<xsl:variable name="wn31lexsense_tail2">
			<xsl:value-of select="substring-after($wn31lexsense_tail1,':')" />
		</xsl:variable>
		<xsl:variable name="wn31lexsense_tail3">
			<xsl:value-of select="substring-after($wn31lexsense_tail2,':')" />
		</xsl:variable>

		<!-- assume: stable : we do not jump over the part-of-speech boundary /> -->
		<xsl:variable name="sstype">
			<xsl:value-of select="substring-before($wn31lexsense,':')" />
		</xsl:variable>
		<!-- assume: stable : we do not jump over the lexicographer file boundary /> -->
		<xsl:variable name="lexfilenum">
			<xsl:value-of select="substring-before($wn31lexsense_tail1,':')" />
		</xsl:variable>
		<!-- assume: volatile /> -->
		<xsl:variable name="lexid">
			<xsl:value-of select="format-number($senseidx - 1,'00')" />
		</xsl:variable>
		<!-- assume: volatile /> -->
		<xsl:variable name="headword">
			<xsl:choose>
				<xsl:when test="substring-before($wn31lexsense_tail3,':') != ''">
					<!-- <xsl:value-of select="'xxx'" /> -->
					<xsl:value-of select="substring-before($wn31lexsense_tail3,':')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- assume: may change /> -->
		<xsl:variable name="headid">
			<xsl:choose>
				<xsl:when test="substring-after($wn31lexsense_tail3,':') != ''">
					<!-- <xsl:value-of select="'xxx'" /> -->
					<xsl:value-of select="substring-after($wn31lexsense_tail3,':')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:value-of select="concat($lemma,'%',$sstype,':',$lexfilenum,':',$lexid,':',$headword,':',$headid)" />

	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template name="string-replace-all">
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="by" />
		<xsl:choose>
			<xsl:when test="$text = '' or $replace = '' or not($replace)">
				<!-- Stop recursion -->
				<xsl:value-of select="$text" />
			</xsl:when>
			<xsl:when test="contains($text, $replace)">
				<!-- Recurse -->
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:value-of select="$by" />
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="substring-after($text,$replace)" />
					<xsl:with-param name="replace" select="$replace" />
					<xsl:with-param name="by" select="$by" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--
	<xsl:template match="text()">
		<xsl:value-of select="normalize-space()" />
	</xsl:template>
	-->
	
</xsl:transform>
