<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:import href = 'make-satellite_head.xsl' />
	
	<xsl:variable name='debug' select='true()' />
	<xsl:variable name='restrict' select="'unpolluted%5:00:00:pure:02'" />
	<apply-imports />

</xsl:transform>
