<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <!-- Verarbeitungsprozeß:
        Herunterladen aller DHc-Dateien
        Umbenennen (rename *.dhc *.zip)
        Extrahieren Ordner
        Extrahieren XML, verschieben nach input\xml
        Verschieben Bilder
    -->
    <!-- Testen:
    Vorhandensein von 
        Titel, Untertitel
        Autoren, 
        Text, 
        Bildern 
        Bibliographie
    -->
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="folder">
        <xsl:choose>
            <xsl:when test="//*:folder">
                <xsl:value-of select="//*:folder[1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>xml</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="files" select="collection(concat($folder,'/?recurse=yes;select=*.xml'))"/>
    <xsl:template match="/">
        <xsl:result-document href="images/bilder.bat" method="text" encoding="utf-8">
<!--            Erzeuge eine .bat-Datei, mit der die bilder aus dem originalen Ordner in einen Zielordner kopiert werden und dabei normalisiert benannt werden.-->
            <xsl:variable name="imagetypes" select="$files//graphic/@url[not(starts-with(., 'http'))]/tokenize(., '\.')[last()]"/>
            <xsl:text>REM </xsl:text>
            <xsl:for-each select="distinct-values($imagetypes)"><xsl:value-of select="."/><xsl:text>, </xsl:text></xsl:for-each><xsl:text>
</xsl:text>
            <xsl:text>REM online-Bilder
</xsl:text>
            <xsl:for-each select="$files//graphic/@url[starts-with(., 'http')]">
                <xsl:text>curl </xsl:text><xsl:value-of select="."/><xsl:text> -O
</xsl:text>
            </xsl:for-each>
            <xsl:text>REM Bilder aus den DHc-Dateien
</xsl:text>
            <xsl:for-each select="$files">
                <xsl:variable name="docuri" select="document-uri(.)"/>
                <xsl:variable name="filename" select="tokenize(document-uri(.),'/')[last()]"/>
                <xsl:variable name="current-folder" select="replace(replace(substring-after(substring-before($docuri, $filename),'file:/'), '/', '\\'), '%20', ' ')"/>
                <xsl:for-each select=".//graphic">
                    <xsl:variable name="image-file-name" select="replace(tokenize(@url,'/')[last()], '/', '\\')"/>
                    <!-- 1. Erzeuge Unterverzeichnis Pictures und verschiebe die Bilddateien dorthin -->
                    <xsl:text>mkdir "</xsl:text>
                    <xsl:value-of select="$current-folder"/>
                    <xsl:text>Pictures\</xsl:text>
                    <xsl:text>"
move "</xsl:text>
                    <xsl:value-of select="$current-folder"/>
                    <xsl:value-of select="$image-file-name"/>
                    <xsl:text>" "</xsl:text>
                    <xsl:value-of select="$current-folder"/>
                    <xsl:text>Pictures\</xsl:text>
                    <xsl:value-of select="$image-file-name"/><xsl:text>"
</xsl:text>
                    <!-- 2. Kopiere sie in input/images/{filename}-{imagename} -->
                    <xsl:text>copy "</xsl:text>
                    <xsl:value-of select="$current-folder"/>
                    <xsl:text>Pictures\</xsl:text>
                    <xsl:value-of select="$image-file-name"/>
                    <xsl:text>" </xsl:text>
                    <xsl:value-of select="replace(substring-before($filename, '.xml'), ' ', '_')"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="$image-file-name"/><xsl:text>
</xsl:text></xsl:for-each>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="Bibliographie.html">
            <html>
                <head>
                    <title>Bibliographien</title>
                    <meta charset="utf-8"/>
                    <style>
                        .bold {font-weight:bold;}
                        .italic {font-style:italic;}
                    </style>
                </head>
                <body>
                    <xsl:for-each select="$files">
                        <xsl:variable name="filename" select="tokenize(document-uri(.),'/')[last()]"/>
                        <div><h1><a href="xml/{$filename}"><xsl:value-of select="$filename"/></a></h1>
                        <ul>
                            <xsl:apply-templates select=".//bibl" mode="bibl.html"/>
                        </ul>
                        </div>
                    </xsl:for-each>
                </body>
            </html>
        </xsl:result-document>
        <xsl:result-document href="Bibliographie.xml">
            <TEI xmlns="http://www.tei-c.org/ns/1.0">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title></title>
                        </titleStmt>
                        <publicationStmt></publicationStmt>
                        <sourceDesc></sourceDesc>
                    </fileDesc>
                </teiHeader>
                <text>
                    <body>
                        <listBibl>
                            <xsl:for-each select="$files//bibl">
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                        </listBibl>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
        <html><head><title>XML-Test</title><style>
            .Achtung {font-weight:bold;}
            .contrib {border-style: solid;
                page-break-inside:avoid;}
            img {display:block}
            .authorname {font-variant: small-caps;}
        </style>
            <meta charset="utf-8"/>
        </head>
            <body>
                <xsl:for-each select="$files">
                    <xsl:sort select="document-uri(.)"></xsl:sort>
                    <xsl:variable name="filename" select="tokenize(document-uri(.),'/')[last()]"/>
                    <xsl:variable name="current-folder" select="replace(replace(substring-after(substring-before(document-uri(.), $filename),'file:/'), '/', '\\'), '%20', ' ')"/>
                    <!-- Kopiere XML-Dateien in das XML-Verzeichnis -->
<!--                    <xsl:result-document href="xml/{$filename}">
                        <xsl:copy-of select="."/>
                    </xsl:result-document>
-->                    <div id="document-uri(.)" class="contrib">
                        <p>Datei: <a href="{document-uri(.)}"><xsl:value-of select="tokenize(document-uri(.),'/')[last()]"/></a></p>
                        <p>Typ: <xsl:value-of select=".//keywords[@scheme='ConfTool'][@n='subcategory']/term"/></p>
                        <p>Titel: <xsl:value-of select="/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/title"/></p>
                        <p>Autoren: <xsl:apply-templates select="/TEI/teiHeader/fileDesc/titleStmt/author"/></p>
                        <p>Text: <xsl:value-of select="string-length(/TEI/text/body/string())"/><xsl:text> Zeichen </xsl:text>
                            <xsl:if test="string-length(/TEI/text/body/string()) lt 4000"><span class="Achtung">ACHTUNG: Text kürzer als 5000 Zeichen</span></xsl:if></p>
                        <p>Überschriften: <xsl:value-of select="count(.//head)"/> <xsl:if test="count(.//head) = 0"><xsl:text> </xsl:text><span class="Achtung">Achtung, keine Überschriften im TEI</span></xsl:if></p>
                        <xsl:if test=".//graphic"><p>Bilder: (Ordner: <a href="../input/images/{
                            replace(substring-before($filename, '.xml'), ' ', '_')
                            }">../input/images/<xsl:value-of select="replace(substring-before($filename, '.xml'), ' ', '_')"/></a>
                            <xsl:for-each select=".//graphic">
                                <xsl:variable name="image-file-name" select="replace(tokenize(@url,'/')[last()], '/', '\\')"/>
                                <img alt="ACHTUNG! {@url}" src="../input/images/{
                                replace(substring-before($filename, '.xml'), ' ', '_')
                                }-{
                                $image-file-name
                                }" height="100"/></xsl:for-each>
                        </p></xsl:if> 
                        <p>Bibliographie: <xsl:value-of select="count(.//bibl)"/><xsl:if test="count(.//bibl) = 0"><span class="Achtung">ACHTUNG! Keine Bibliographie!</span></xsl:if>
                            <xsl:if test=".//bibl[not(hi)]"><ul><xsl:for-each select=".//bibl[not(hi)]"><xsl:apply-templates select="."/></xsl:for-each></ul></xsl:if></p>
                    </div>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="hi">
        <span class="{@rend}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="bibl">
        <xsl:if test="not(hi)"><li class="Achtung">ACHTUNG, keine Formatierung in: <xsl:value-of select="."/></li></xsl:if>
    </xsl:template>
    <xsl:template match="bibl" mode="bibl.html">
        <li><xsl:apply-templates/></li>
    </xsl:template>
    <xsl:template match="author">
        <xsl:apply-templates/><xsl:text>; </xsl:text>
    </xsl:template>
    
    <xsl:template match="author/persName">
        <span class="author"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="author/persName/surname">
        <span class="authorname"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="affiliation">
        <xsl:text> (</xsl:text><xsl:apply-templates/><xsl:text>) </xsl:text>
    </xsl:template>
</xsl:stylesheet>