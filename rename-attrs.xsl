<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ili="http://ili.org/ili/"
	xmlns:meta="https://github.com/globalwordnet/schemas" xmlns:pwn="http://www.princeton.edu/princeton/">

	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes" />

	<!-- in -->
	<xsl:variable name="ns_dc" select="'http://purl.org/dc/elements/1.1/'" />

	<!-- out -->
	<xsl:variable name="ns_ili" select="'http://ili.org/ili/'" />
	<xsl:variable name="ns_meta" select="'https://github.com/globalwordnet/schemas'" />
	<xsl:variable name="ns_pwn" select="'http://www.princeton.edu/princeton/'" />

	<!-- <xsl:template match="/"> -->
	<!-- <xsl:apply-templates select="LexicalResource" /> -->
	<!-- </xsl:template> -->

	<xsl:template match="LexicalResource">
		<LexicalResource xmlns:pwn="http://www.princeton.edu/princeton/" xmlns:ili="http://ili.org/ili/"
			xmlns:meta="https://github.com/globalwordnet/schemas">
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates select="*" />
		</LexicalResource>
	</xsl:template>

	<xsl:template match="*">

<!-- 		<xsl:message> -->
<!-- 			<xsl:text>ele </xsl:text> -->
<!-- 			<xsl:value-of select="name()" /> -->
<!-- 		</xsl:message> -->

		<xsl:copy select=".">

			<xsl:for-each select="@*">
				<!-- <xsl:message> -->
				<!-- <xsl:text>attr0 </xsl:text> -->
				<!-- <xsl:value-of select="name()" /> -->
				<!-- <xsl:text> </xsl:text> -->
				<!-- <xsl:value-of select="namespace-uri()" /> -->
				<!-- </xsl:message> -->

				<xsl:choose>
					<xsl:when test="namespace-uri() = $ns_dc">
						<!-- <xsl:message> -->
						<!-- <xsl:text>dc:attr </xsl:text> -->
						<!-- <xsl:value-of select="name()" /> -->
						<!-- </xsl:message> -->

						<xsl:choose>
							<xsl:when test="local-name()='identifier'">
								<xsl:attribute name="pwn:sensekey">
									<xsl:value-of select="." />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="local-name()='subject'">
								<xsl:attribute name="lexfile2">
									<xsl:value-of select="." />
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="{concat('meta:',local-name())}">
									<xsl:value-of select="." />
								</xsl:attribute>
								<xsl:message>
									<xsl:text>dc:</xsl:text>
									<xsl:value-of select="local-name()" />
									<xsl:text> to meta:</xsl:text>
									<xsl:value-of select="local-name()" />
								</xsl:message>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>

					<xsl:when test="namespace-uri() != ''">
						<xsl:message>
							<xsl:text>not captured ns </xsl:text>
							<xsl:value-of select="namespace-uri()" />
						</xsl:message>
					</xsl:when>

					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="local-name()='ili'">
								<xsl:attribute name="ili:id">
									<xsl:value-of select="." />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="local-name()='status'">
								<xsl:attribute name="meta:status">
									<xsl:value-of select="." />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="local-name()='note'">
								<xsl:attribute name="meta:note">
									<xsl:value-of select="." />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="local-name()='confidenceScore'">
								<xsl:attribute name="meta:confidenceScore">
									<xsl:value-of select="." />
								</xsl:attribute>
							</xsl:when>

							<xsl:otherwise>
								<xsl:copy>
									<xsl:value-of select="." />
								</xsl:copy>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			<xsl:copy-of select="text()" />
			
			<xsl:apply-templates select="node()" />			

		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:value-of select="." />
	</xsl:template>

	<xsl:template match="text()">
		<xsl:message>
			<xsl:text>text </xsl:text>
			<xsl:value-of select="." />
		</xsl:message>
		<xsl:copy-of select="comment()" />
	</xsl:template>

	<xsl:template match="comment()">
		<xsl:message>
			<xsl:text>comment </xsl:text>
			<xsl:value-of select="." />
		</xsl:message>
		<xsl:copy-of select="comment()" />
	</xsl:template>

</xsl:transform>
