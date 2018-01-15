<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <!-- Testen:
    Vorhandensein von 
        Titel, Untertitel
        Autoren, 
        Text, 
        Bildern 
        Bibliographie
    -->
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="files" select="collection('xml/?select=*.xml')"/>
    <xsl:template match="/">
        <xsl:result-document href="Bilder.txt">
            <xsl:for-each select="$files">
                <xsl:variable name="filename" select="tokenize(document-uri(.),'/')[last()]"/>
<!--                <xsl:value-of select="$filename"/>-->
                <xsl:for-each select=".//graphic"><xsl:value-of select="replace(substring-before($filename, '.xml'), ' ', '_')"/><xsl:text>: </xsl:text><xsl:value-of select="@url"/><xsl:text>

                </xsl:text></xsl:for-each>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="Bibliographie.xml">
            <TEI xmlns="http://www.tei-c.org/ns/1.0"><xsl:for-each select="$files//bibl">
                <xsl:copy-of select="."/>
            </xsl:for-each></TEI>
        </xsl:result-document>
        <html><head><title>XML-Test</title><style>
            .Achtung {font-weight:bold;}
            .contrib {border-style: solid}
            img {display:block}
        </style>
            <meta charset="utf-8"/>
        </head>
            <body><xsl:for-each select="$files">
            <xsl:variable name="filename" select="tokenize(document-uri(.),'/')[last()]"/>
            <div id="document-uri(.)" class="contrib">
                <p>Datei: <a href="{document-uri(.)}"><xsl:value-of select="tokenize(document-uri(.),'/')[last()]"/></a></p>
                <p>Typ: <xsl:value-of select=".//keywords[@scheme='ConfTool'][@n='subcategory']/term"/></p>
                <p>Titel: <xsl:value-of select="/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/title"/></p>
                <p>Autoren: <xsl:apply-templates select="/TEI/teiHeader/fileDesc/titleStmt/author"/></p>
                <p>Text: <xsl:value-of select="string-length(/TEI/text/body/string())"/>
                    <xsl:if test="string-length(/TEI/text/body/string()) lt 5000"><span class="Achtung">ACHTUNG: Text kürzer als 5000 Zeichen</span></xsl:if></p>
                <p>Überschriften: <xsl:if test="count(.//head) = 0"><span class="Achtung">Achtung, keine Überschriften im TEI</span></xsl:if></p>
                <xsl:if test=".//graphic"><p>Bilder: (Ordner: <a href="../input/images/{
                    replace(substring-before($filename, '.xml'), ' ', '_')
                    }">../input/images/<xsl:value-of select="replace(substring-before($filename, '.xml'), ' ', '_')"/></a>
                    <xsl:for-each select=".//graphic"><img alt="{@url}" src="../input/images/{
                        replace(substring-before($filename, '.xml'), ' ', '_')
                        }/{
                        @url/substring-after(.,'Pictures/')
                        }" height="100"/></xsl:for-each>
                </p></xsl:if> 
                <p>Bibliographie: <xsl:value-of select="count(.//bibl)"/><xsl:if test="count(.//bibl) = 0"><span class="Achtung">ACHTUNG! Keine Bibliographie!</span></xsl:if>
                    <xsl:if test=".//bibl[not(hi)]"><ul><xsl:for-each select=".//bibl[not(hi)]"><xsl:apply-templates select="."/></xsl:for-each></ul></xsl:if></p>
            </div>
        </xsl:for-each></body></html>
    </xsl:template>
    <xsl:template match="bibl">
        <xsl:if test="not(hi)"><li class="Achtung">ACHTUNG, keine Formatierung in: <xsl:value-of select="."/></li></xsl:if>
    </xsl:template>
    <xsl:template match="author">
        <xsl:value-of select="."/><xsl:text>; </xsl:text>
    </xsl:template>
</xsl:stylesheet>