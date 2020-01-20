<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes" />

	<xsl:param name="updateFileName" select="'verbtemplates.xml'" />
	<xsl:param name="updates" select="document($updateFileName)" />
	<xsl:param name="textFileName" select="'verbtemplatetexts.xml'" />
	<xsl:param name="texts" select="document($textFileName)" />

	<xsl:variable name='debug' select='true()' />

	<xsl:template match="/">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="LexicalResource">
		<LexicalResource xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation=". https://1313ou.github.io/ewn-validation/WN-LMF-1.5-relax_idrefs.xsd">
			<xsl:apply-templates select="./*" />
<!-- 			<xsl:apply-templates select="./Lexicon/LexicalEntry/Sense" /> -->
		</LexicalResource>
	</xsl:template>

	<xsl:template match="Sense" xmlns:dc="http://purl.org/dc/elements/1.1/">

		<xsl:variable name="sensekey" select="./@sensekey" />
		<xsl:variable name="sensekey31" select="./@dc:identifier" />
		<xsl:variable name="rows" select="$updates/DATA/ROW[sensekey31/text() = $sensekey31]" />

		<xsl:if test="count($rows)>0">
			<xsl:for-each select="$rows">
				<xsl:variable name="row" select="." />
				<xsl:variable name="templates" select="$row/template" />

				<xsl:if test="count($templates)>0">
					<xsl:message>
						<xsl:text>sense </xsl:text>
						<xsl:value-of select="$sensekey" />
						<xsl:if test="$sensekey !=$sensekey31">
							<xsl:text> skwn31=</xsl:text>
							<xsl:value-of select="$sensekey31" />
						</xsl:if>
					</xsl:message>
					<xsl:for-each select="./template">
						<xsl:variable name="template" select="." />
						<xsl:variable name="templaterow" select="$texts/DATA/ROW[id/text() = $template]" />
						<xsl:variable name="templatetext" select="$templaterow/sentence/text()" />

						<xsl:message>
							<xsl:text> template </xsl:text>
							<xsl:value-of select="$template" />
							<xsl:text> sentence </xsl:text>
							<xsl:text>"</xsl:text>
							<xsl:value-of select="$templatetext" />
							<xsl:text>"</xsl:text>
						</xsl:message>

					</xsl:for-each>
				</xsl:if>

			</xsl:for-each>
		</xsl:if>

	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>


</xsl:transform>
