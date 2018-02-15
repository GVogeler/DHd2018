<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" >

  <xsl:output indent="no"/><!-- Wed, 22 Jun 2016 10:02:03 +0200 moocow: indent="yes" breaks manual formatting (e.g. for subscripts) -->
  <!--<xsl:strip-space elements="*"/>-->
  <!--<xsl:preserve-space elements="bibl"/>-->

  <!-- Two outputs are: print or pdf. This adjusts colors (for headers), margins, and a few other small things -->
  <xsl:variable name="output">pdf</xsl:variable>

  <!-- Print paper ID's: yes or no -->
  <xsl:variable name="id">no</xsl:variable>


  <!-- =================================================================================
  XSL to create xsl-fo file from the combined TEI Corpus file.
  You'll want to run TEIcorpus_producer.xsl first.

  v.1 Created for Digital Humanities 2013 at the University of Nebraska-Lincoln by Karin Dalziel


  Sections are as follows:

  Attribute sets - all fonts and page dimentions set here.
  Variables and templates for content - called throughout file
  Page Layouts - fo-master-set
  Page templates & Flow - actual content is written to files
  TEI style templates - where the TEI is styled

  ================================================================================= -->


  <!-- =================================================================================
  Attribute sets to set fonts, page properties, etc
  ================================================================================= -->

  <!-- Pages -->
  <xsl:template name="page_full">
    <xsl:attribute name="page-height">297mm</xsl:attribute>
    <xsl:attribute name="page-width">210mm</xsl:attribute>
    <xsl:attribute name="margin-top">0in</xsl:attribute>
    <xsl:attribute name="margin-bottom">0in</xsl:attribute>
    <xsl:attribute name="margin-left">0in</xsl:attribute>
    <xsl:attribute name="margin-right">0in</xsl:attribute>
  </xsl:template>

  <xsl:template name="page_even">
    <xsl:attribute name="page-height">297mm</xsl:attribute>
    <xsl:attribute name="page-width">210mm</xsl:attribute>
    <xsl:attribute name="margin-top">0.5in</xsl:attribute>
    <xsl:attribute name="margin-bottom">0.5in</xsl:attribute>
    <!-- Stagger the pages for print but not PDF -->
    <xsl:choose>
      <xsl:when test="$output = 'print'">
        <xsl:attribute name="margin-left">0.5in</xsl:attribute>
        <xsl:attribute name="margin-right">1in</xsl:attribute>
      </xsl:when>
      <xsl:when test="$output = 'pdf'">
        <xsl:attribute name="margin-left">.75in</xsl:attribute>
        <xsl:attribute name="margin-right">.75in</xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="page_odd">
    <xsl:attribute name="page-height">297mm</xsl:attribute>
    <xsl:attribute name="page-width">210mm</xsl:attribute>
    <xsl:attribute name="margin-top">0.5in</xsl:attribute>
    <xsl:attribute name="margin-bottom">0.5in</xsl:attribute>
    
<!-- Stagger the pages for print but not PDF -->
    <xsl:choose>
      <xsl:when test="$output = 'print'">
        <xsl:attribute name="margin-left">1in</xsl:attribute>
        <xsl:attribute name="margin-right">.5in</xsl:attribute>
      </xsl:when>
      <xsl:when test="$output = 'pdf'">
        <xsl:attribute name="margin-left">.75in</xsl:attribute>
        <xsl:attribute name="margin-right">.75in</xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="single_column">
    <xsl:attribute name="margin-top">0.5in</xsl:attribute>
    <xsl:attribute name="margin-bottom">0.5in</xsl:attribute>
  </xsl:template>

  <xsl:template name="double_column">
    <xsl:attribute name="column-count">2</xsl:attribute>
    <xsl:attribute name="column-gap">.25in</xsl:attribute>
    <xsl:attribute name="margin-bottom">.5in</xsl:attribute>
    <xsl:attribute name="margin-top">.5in</xsl:attribute>
  </xsl:template>

  <xsl:template name="triple_column">
    <xsl:attribute name="column-count">3</xsl:attribute>
    <xsl:attribute name="column-gap">.25in</xsl:attribute>
    <xsl:attribute name="margin-bottom">.5in</xsl:attribute>
    <xsl:attribute name="margin-top">.5in</xsl:attribute>
  </xsl:template>


  <!-- =====================
  FONTS
  ===========================-->

  <xsl:variable name="main_font">Noto Serif</xsl:variable>
  <xsl:variable name="header_font">Noto Sans</xsl:variable>
  <xsl:variable name="monospace_font">monospace</xsl:variable>

  <!-- Language specific rules -->

  <xsl:template name="chinese">
    <xsl:attribute name="font-style">normal</xsl:attribute>
    <xsl:attribute name="font-family">Noto Sans CJK TC</xsl:attribute>
  </xsl:template>

  <xsl:template name="ethiopic">
    <xsl:attribute name="font-style">normal</xsl:attribute>
    <xsl:attribute name="font-family">Noto Sans Ethiopic</xsl:attribute>
  </xsl:template>

  <xsl:template name="japanese">
    <xsl:attribute name="font-style">normal</xsl:attribute>
    <xsl:attribute name="font-family">Arial Unicode MS</xsl:attribute>
  </xsl:template>

  <xsl:template name="hebrew">
    <xsl:attribute name="font-family">Noto Sans Hebrew</xsl:attribute>
    <xsl:attribute name="direction">ltr</xsl:attribute>
  </xsl:template>

  <xsl:template name="math">
    <xsl:attribute name="font-style">normal</xsl:attribute>
    <xsl:attribute name="font-family">Arial Unicode MS</xsl:attribute>
  </xsl:template>

  <xsl:template name="math_alt_font">
    <xsl:attribute name="font-style">normal</xsl:attribute>
    <xsl:attribute name="font-family">Arial Unicode MS</xsl:attribute>
  </xsl:template>

  <xsl:template name="fraction">
    <xsl:value-of select="./hi[@rend='over']" />
    <xsl:text>/</xsl:text>
    <xsl:value-of select="./hi[@rend='under']" />
  </xsl:template>

  <xsl:template name="sameline">
    <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
  </xsl:template>

  <!-- Super and sub script -->

  <xsl:template name="superscript">
    <xsl:attribute name="vertical-align">super</xsl:attribute>
    <xsl:attribute name="font-size">6pt</xsl:attribute>
  </xsl:template>

  <xsl:template name="subscript">
    <xsl:attribute name="vertical-align">sub</xsl:attribute>
    <xsl:attribute name="font-size">8pt</xsl:attribute>
  </xsl:template>

  <!-- headers and footers -->
  <!-- static level -->
  <xsl:template name="header_and_footer-even">
    <xsl:attribute name="color">#aaa</xsl:attribute>
    <xsl:if test="$output = 'pdf'">
      <xsl:attribute name="text-align">right</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="header_and_footer-odd">
    <xsl:attribute name="color">#aaa</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:template>

  <!-- block level -->
  <xsl:template name="page_header">
    <xsl:attribute name="border-bottom">solid</xsl:attribute>
    <xsl:attribute name="border-color">#aaaaaa</xsl:attribute>
    <xsl:attribute name="color">#aaaaaa</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="page_footer">
    <xsl:attribute name="color">#aaaaaa</xsl:attribute>
    <xsl:attribute name="padding-top">.25in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>



  <!-- Intro specific text and headers -->

  <!-- Used for publication information -->
  <xsl:template name="intro_text">
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="color">black</xsl:attribute>
    <xsl:attribute name="space-before">.2in</xsl:attribute>
    <xsl:attribute name="space-after">.2in</xsl:attribute>
  </xsl:template>

  <xsl:template name="publisher_info">
    <xsl:attribute name="margin-top">6.2in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="intro_text_center">
    <xsl:attribute name="text-indent">.2in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="color">black</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:template>

  <xsl:template name="intro_text_italic">
    <xsl:attribute name="text-indent">.2in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="color">black</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
  </xsl:template>

  <xsl:template name="intro_text_italic_center">
    <xsl:attribute name="text-indent">.2in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="color">black</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
  </xsl:template>

  <xsl:template name="intro_head_large_center">
    <xsl:attribute name="font-family"><xsl:value-of select="$header_font"/></xsl:attribute>
    <xsl:attribute name="font-size">40pt</xsl:attribute>
    <xsl:attribute name="color">#000</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="space-before">2in</xsl:attribute>
    <xsl:attribute name="space-after">.2in</xsl:attribute>
  </xsl:template>

  <xsl:template name="intro_head_medium_center">
    <xsl:attribute name="font-family"><xsl:value-of select="$header_font"/></xsl:attribute>
    <xsl:attribute name="font-size">16pt</xsl:attribute>
    <xsl:attribute name="color">#000</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:template>

  <xsl:template name="intro_head_small">
    <xsl:attribute name="font-family"><xsl:value-of select="$header_font"/></xsl:attribute>
    <xsl:attribute name="font-size">14pt</xsl:attribute>
    <xsl:attribute name="color">black</xsl:attribute>
  </xsl:template>

  <xsl:template name="intro_head_medium_italic_center">
    <xsl:attribute name="font-family"><xsl:value-of select="$header_font"/></xsl:attribute>
    <xsl:attribute name="font-size">16pt</xsl:attribute>
    <xsl:attribute name="color">#000</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
  </xsl:template>

  <xsl:template name="figure_container_intro">
    <xsl:attribute name="space-before">1in</xsl:attribute>
    <xsl:attribute name="space-after">.2in</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="figure_intro">
    <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
    <xsl:attribute name="content-width">5in</xsl:attribute>
    <xsl:attribute name="scaling">non-uniform</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>



  <!-- heads -->

  <xsl:template name="head">
    <xsl:attribute name="font-family"><xsl:value-of select="$header_font"/></xsl:attribute>
    <xsl:attribute name="font-size">20pt</xsl:attribute>
    <xsl:attribute name="page-break-inside">avoid</xsl:attribute>
    <xsl:choose>
      <xsl:when test="$output = 'print'">
        <xsl:attribute name="color">#000</xsl:attribute>
      </xsl:when>
      <xsl:when test="$output = 'pdf'">
        <xsl:attribute name="color">#d00011</xsl:attribute><!-- red -->
      </xsl:when>
    </xsl:choose>
    <xsl:attribute name="space-before">.2in</xsl:attribute>
    <xsl:attribute name="space-after">.2in</xsl:attribute>
  </xsl:template>

  <xsl:template name="subhead">
    <xsl:attribute name="font-family"><xsl:value-of select="$header_font"/></xsl:attribute>
    <xsl:attribute name="font-size">16pt</xsl:attribute>
    <xsl:attribute name="color">#000</xsl:attribute>
    <xsl:attribute name="space-before">.2in</xsl:attribute>
    <xsl:attribute name="space-after">.2in</xsl:attribute>
    <xsl:attribute name="page-break-inside">avoid</xsl:attribute>
  </xsl:template>

  <xsl:template name="subsubhead">
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    <xsl:attribute name="font-size">16pt</xsl:attribute>
    <xsl:attribute name="color">black</xsl:attribute>
    <xsl:attribute name="space-before">.2in</xsl:attribute>
    <xsl:attribute name="space-after">.2in</xsl:attribute>
  </xsl:template>

  <!-- This is just getting silly... -->
  <xsl:template name="subsubsubhead">
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    <xsl:attribute name="font-size">14pt</xsl:attribute>
    <xsl:attribute name="color">black</xsl:attribute>
    <xsl:attribute name="space-before">.2in</xsl:attribute>
    <xsl:attribute name="space-after">.2in</xsl:attribute>
  </xsl:template>

  <xsl:template name="text_bigger">
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    <xsl:attribute name="font-size">14pt</xsl:attribute>
    <xsl:attribute name="color">black</xsl:attribute>
  </xsl:template>

  <xsl:template name="text_smaller">
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    <xsl:attribute name="font-size">8pt</xsl:attribute>
    <xsl:attribute name="color">black</xsl:attribute>
  </xsl:template>

  <xsl:template name="section_head"> <!-- For Panel, Paper, and Poster head pages-->
    <xsl:attribute name="font-family"><xsl:value-of select="$header_font"/></xsl:attribute>
    <xsl:attribute name="font-size">40pt</xsl:attribute>
    <xsl:choose>
      <xsl:when test="$output = 'print'">
        <xsl:attribute name="color">#000</xsl:attribute>
      </xsl:when>
      <xsl:when test="$output = 'pdf'">
        <xsl:attribute name="color">#d00011</xsl:attribute><!-- red -->
      </xsl:when>
    </xsl:choose>
    <xsl:attribute name="margin-top">3in</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:template>

  <!-- authors -->

  <xsl:template name="author_name">
    <xsl:attribute name="font-size">14pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="author_email">
  </xsl:template>

  <xsl:template name="author_info">
    <xsl:attribute name="space-after">.2in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="toc_author">
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="margin-left">1em</xsl:attribute>
  </xsl:template>

  <xsl:template name="blockquote">
    <xsl:attribute name="space-before">.5em</xsl:attribute>
    <xsl:attribute name="space-after">.5em</xsl:attribute>
    <xsl:attribute name="margin-left">.2in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <!-- Text -->
  <xsl:template name="text">
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="color">black</xsl:attribute>
  </xsl:template>

  <xsl:template name="plain_text">
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="color">black</xsl:attribute>
    <xsl:attribute name="text-indent">0in</xsl:attribute>
  </xsl:template>

  <xsl:template name="p">
    <xsl:attribute name="text-indent">.1in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    <!--<xsl:attribute name="space-before">.2in</xsl:attribute>
    <xsl:attribute name="space-after">.2in</xsl:attribute>-->
  </xsl:template>

  <xsl:template name="p_center">
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="plain-block">
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="line-group">
    <xsl:attribute name="space-before">.1in</xsl:attribute>
    <xsl:attribute name="space-after">.1in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="p_inlist">
    <xsl:attribute name="space-before">.1in</xsl:attribute>
    <xsl:attribute name="space-after">.1in</xsl:attribute>
   <!-- <xsl:attribute name="margin-left">-1.6em</xsl:attribute>
   -->
    <xsl:attribute name="text-indent">0em</xsl:attribute>
    <xsl:attribute name="margin-bottom">.1in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="list_item_label">
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="list-item-body">
    <xsl:attribute name="margin-left">.05in</xsl:attribute>
    <xsl:attribute name="text-indent">-1.2em</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <!-- only included for top level lists, not for sub lists -->
  <xsl:template name="list_margins">
    <xsl:attribute name="space-before">.1in</xsl:attribute>
    <xsl:attribute name="space-after">.1in</xsl:attribute>
    <xsl:attribute name="margin-bottom">.1in</xsl:attribute>
  </xsl:template>

  <xsl:template name="list">
    <xsl:attribute name="margin-left">0.4em</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="back">
    <xsl:attribute name="space-before">.2in</xsl:attribute>
    <xsl:attribute name="space-after">.2in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="italic">
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="underline">
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <!--<xsl:attribute name="text-decoration">underline</xsl:attribute>-->
  </xsl:template>

  <xsl:template name="smallcaps">
    <xsl:attribute name="font-variant">small-caps</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="bold">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <!-- Figures -->
  <xsl:template name="figure_container">
    <xsl:attribute name="space-before">.2in</xsl:attribute>
    <xsl:attribute name="space-after">.2in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="figure">
    <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
    <xsl:attribute name="content-width">3.15in</xsl:attribute>
    <xsl:attribute name="scaling">non-uniform</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="figure_head">
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    
    <xsl:attribute name="margin-left">.1in</xsl:attribute>
    <xsl:attribute name="space-before">.1in</xsl:attribute>
    <xsl:attribute name="space-after">.1in</xsl:attribute>
  </xsl:template>

  <xsl:template name="figure_p">
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
    <xsl:attribute name="space-before">.1in</xsl:attribute>
    <xsl:attribute name="space-after">.1in</xsl:attribute>
  </xsl:template>

  <xsl:template name="code">
    <xsl:attribute name="font-family"><xsl:value-of select="$monospace_font"/></xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
  </xsl:template>

  <!-- Tables -->
  <xsl:template name="table_smaller">
    <xsl:attribute name="space-before">.2in</xsl:attribute>
    <xsl:attribute name="space-after">.2in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="table">
    <xsl:attribute name="space-before">.2in</xsl:attribute>
    <xsl:attribute name="space-after">.2in</xsl:attribute>
    <xsl:attribute name="keep-together.within-column">1</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <xsl:template name="cell">
    <xsl:attribute name="border">solid</xsl:attribute>
    <xsl:attribute name="border-color">gray</xsl:attribute>
    <xsl:attribute name="border-width">thin</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="padding">.02in</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$main_font"/></xsl:attribute>
  </xsl:template>

  <!-- =================================================================================
  Variables and templates for content
  ================================================================================= -->

  <!-- Header and Footer variable code -->
  <xsl:variable name="header_and_footer">
    <fo:static-content flow-name="before-even">
      <xsl:call-template name="header_and_footer-even"/>
      <fo:block><xsl:call-template name="page_header"/>Digital Humanities im deutschsprachigen Raum 2018</fo:block>
    </fo:static-content>
    <fo:static-content flow-name="after-even">
      <xsl:call-template name="header_and_footer-even"/>
      <fo:block><xsl:call-template name="page_footer"/><fo:page-number/></fo:block>
    </fo:static-content>
    <fo:static-content flow-name="before-odd">
      <xsl:call-template name="header_and_footer-odd"/>
      <fo:block><xsl:call-template name="page_header"/>Digital Humanities im deutschsprachigen Raum 2018</fo:block>
    </fo:static-content>
    <fo:static-content flow-name="after-odd">
      <xsl:call-template name="header_and_footer-odd"/>
      <fo:block><xsl:call-template name="page_footer"/><fo:page-number/></fo:block>
    </fo:static-content>
  </xsl:variable>

  <!-- Templates for TOC Headers -->

  <xsl:template match="//term[text()='Keynote']" mode="toc">
    <xsl:if test="(//term[text()='Keynote'])[1] is ."><fo:block keep-with-next="always"><xsl:call-template name="subhead"/>Keynotes</fo:block></xsl:if>
  </xsl:template>

  <xsl:template match="//term[text()='Workshop']" mode="toc">
    <xsl:if test="(//term[text()='Workshop'])[1] is ."><fo:block keep-with-next="always"><xsl:call-template name="subhead"/>Workshops</fo:block></xsl:if>
  </xsl:template>

  <xsl:template match="//term[text()='Panel']" mode="toc">
    <xsl:if test="(//term[text()='Panel'])[1] is ."><fo:block keep-with-next="always"><xsl:call-template name="subhead"/>Panels</fo:block></xsl:if>
  </xsl:template>

  <xsl:template match="//term[text()='Sektion']" mode="toc">
    <xsl:if test="(//term[text()='Sektion'])[1] is ."><fo:block keep-with-next="always"><xsl:call-template name="subhead"/>Sektionen</fo:block></xsl:if>
  </xsl:template>

  <xsl:template match="//term[text()='Vortrag']" mode="toc">
    <xsl:if test="(//term[text()='Vortrag'])[1] is ."><fo:block keep-with-next="always"><xsl:call-template name="subhead"/>Vorträge</fo:block></xsl:if>
  </xsl:template>

  <xsl:template match="//term[text()='Poster']" mode="toc">
    <xsl:if test="(//term[text()='Poster'])[1] is ."><fo:block keep-with-next="always"><xsl:call-template name="subhead"/>Poster</fo:block></xsl:if>
  </xsl:template>


  <xsl:template match="/">

    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">

      <!-- =================================================================================
      Page Layouts
      ================================================================================= -->

      <fo:layout-master-set>

        <!-- Full Page (for PDF beginning and ending images) -->
        <fo:simple-page-master master-name="Full-even">
          <xsl:call-template name="page_full"/>
          <fo:region-body></fo:region-body>
        </fo:simple-page-master>

        <fo:simple-page-master master-name="Full-odd">
          <xsl:call-template name="page_full"/>
          <fo:region-body></fo:region-body>
        </fo:simple-page-master>

        <fo:page-sequence-master master-name="Full">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="Full-even"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="Full-odd"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <!-- Single Column -->
        <fo:simple-page-master master-name="Single-even">
          <xsl:call-template name="page_even"/>
          <fo:region-body><xsl:call-template name="single_column"/></fo:region-body>
          <fo:region-before region-name="before-even" extent=".5in" />
          <fo:region-after region-name="after-even" extent=".5in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="Single-odd">
          <xsl:call-template name="page_odd"/>
          <fo:region-body><xsl:call-template name="single_column"/></fo:region-body>
          <fo:region-before region-name="before-odd" extent=".5in" />
          <fo:region-after region-name="after-odd" extent=".5in" />
        </fo:simple-page-master>

        <fo:page-sequence-master master-name="Single">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="Single-even"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="Single-odd"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <!-- Double Column -->
        <fo:simple-page-master master-name="Double-even">
          <xsl:call-template name="page_even"/>
          <fo:region-body><xsl:call-template name="double_column"/></fo:region-body>
          <fo:region-before region-name="before-even" extent=".5in" />
          <fo:region-after region-name="after-even" extent=".5in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="Double-odd">
          <xsl:call-template name="page_odd"/>
          <fo:region-body><xsl:call-template name="double_column"/></fo:region-body>
          <fo:region-before region-name="before-odd" extent=".5in" />
          <fo:region-after region-name="after-odd" extent=".5in" />
        </fo:simple-page-master>

        <fo:page-sequence-master master-name="Double">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="Double-even"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="Double-odd"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <!-- Triple Column -->
        <fo:simple-page-master master-name="Triple-even">
          <xsl:call-template name="page_even"/>
          <fo:region-body><xsl:call-template name="triple_column"/></fo:region-body>
          <fo:region-before region-name="before-even" extent=".5in" />
          <fo:region-after region-name="after-even" extent=".5in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="Triple-odd">
          <xsl:call-template name="page_odd"/>
          <fo:region-body><xsl:call-template name="triple_column"/></fo:region-body>
          <fo:region-before region-name="before-odd" extent=".5in" />
          <fo:region-after region-name="after-odd" extent=".5in" />
        </fo:simple-page-master>

        <fo:page-sequence-master master-name="Triple">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="Triple-even"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="Triple-odd"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

      </fo:layout-master-set>





      <!-- =================================================================================
      Page templates & Flow
      ================================================================================= -->

      <!--   Frontmatter
      Table_Of_Contents
      Panels_title
      Panels
      Papers_title
      Papers
      Papers_title
      Papers
      Author_Index-->

      <!-- Beginning image -->

      <xsl:if test="$output = 'pdf'">
        <fo:page-sequence master-reference="Full">
          <fo:flow flow-name="xsl-region-body">
            <fo:block>
              <fo:external-graphic src="../../../input/images/front_cover.jpg" content-width="210mm" content-height="scale-to-fit"/>
            </fo:block>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>




      <!-- Frontmatter -->

      <!-- Intro -->
      <xsl:if test="//keywords[@n='category']/term[1] = 'Intro'">

        <xsl:for-each select="//TEI">
          <!-- if Intro -->
          <xsl:if test="normalize-space(teiHeader[1]/profileDesc[1]/textClass[1]/keywords[@n='category']/term[1]) = 'Intro'">

            <fo:page-sequence>
              <xsl:if test="@n='intro-001'">
                <xsl:attribute name="initial-page-number">1</xsl:attribute>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="text/@n = 'single'">
                  <xsl:attribute name="master-reference">Single</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="master-reference">Double</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:attribute name="format">i</xsl:attribute>
              <!-- Don't apply page numbers to title pages, etc. -->
              <xsl:if test="not(@n='intro-001' or @n='intro-002' or @n='intro-003' or @n='intro-004')"><xsl:copy-of select="$header_and_footer"/></xsl:if>


              <fo:flow flow-name="xsl-region-body">

                <!-- Title -->
                <xsl:if test="not(teiHeader/fileDesc/titleStmt/title[1]/@type = 'nodisplay')">
                  <fo:block id="{@n}">
                    <xsl:call-template name="head"/>
                    <xsl:value-of select="teiHeader/fileDesc/titleStmt/title"/>
                  </fo:block>
                </xsl:if>

                <!-- Authors -->
                <fo:block>
                  <xsl:call-template name="text"/>
                  <xsl:for-each select="teiHeader/fileDesc/titleStmt/author">
                    <fo:block>
                      <xsl:call-template name="author_name"/>
                      <xsl:attribute name="id">
                        <xsl:value-of select="@n"/>
                      </xsl:attribute>
                      <!--<xsl:value-of select="name"/>-->
                    </fo:block>
                  </xsl:for-each>
                </fo:block>
                <!-- Text -->
                <fo:block>
                  <xsl:call-template name="text"/>
                  <xsl:apply-templates select="text"/>
                </fo:block>

              </fo:flow>
            </fo:page-sequence>

          </xsl:if>
        </xsl:for-each>

      </xsl:if>

      <!-- Table of Contents -->
      <fo:page-sequence master-reference="Single">
        <fo:flow flow-name="xsl-region-body">
          <xsl:for-each select="//TEI">
            <!-- Controlled by individual templates below, gives section headers for TOC -->

            <xsl:apply-templates select="teiHeader/profileDesc/textClass/keywords[2]/term[1]" mode="toc"/>

            <xsl:if test="descendant::keywords[@n='subcategory']/term[1] = 'Sektion' or
              descendant::keywords[@n='subcategory']/term[1] = 'Panel' or
              descendant::keywords[@n='subcategory']/term[1] = 'Poster' or
              descendant::keywords[@n='subcategory']/term[1] = 'Workshop' or
              descendant::keywords[@n='subcategory']/term[1] = 'Vortrag' or
              descendant::keywords[@n='subcategory']/term[1] = 'Keynote' or
              descendant::keywords[@n='subcategory']/term[1] = 'Reviewers'">

              <xsl:choose>
                <xsl:when test="descendant::keywords[@n='subcategory']/term[1] = 'Reviewers'">
                  <!-- Reviewers has no authors, so gets a slightly different treatment -->
                  <fo:block text-align-last="justify">
                    <xsl:call-template name="text"/>
                    <xsl:value-of select="teiHeader/fileDesc/titleStmt/title"/><xsl:text> </xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <fo:basic-link internal-destination="{@n}">
                      <fo:page-number-citation letter-spacing="0" ref-id="{@n}" />
                    </fo:basic-link>
                  </fo:block>
                </xsl:when>
                <xsl:otherwise>
                  <!-- When not reviewers, show authors -->
                  <fo:block page-break-inside="avoid">
                    <fo:block margin-right="35mm">
                      <xsl:call-template name="text"/>
                      <xsl:value-of select="teiHeader/fileDesc/titleStmt/title"/>
                    </fo:block>

                    <fo:block text-align-last="justify">
                      <xsl:call-template name="toc_author"/>

                      <fo:inline-container inline-progression-dimension="79.9%">
                        <fo:block>
                          <xsl:for-each select="teiHeader[1]/fileDesc[1]/titleStmt[1]/author/persName[1]">
                            <fo:inline>
                              <!-- <xsl:call-template name="text"/> -->
                              <xsl:value-of select="surname"/>
                              <xsl:text>, </xsl:text>
                              <xsl:value-of select="forename"/>
                              <!-- <xsl:value-of select="normalize-space(.)"/> -->
                              <xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
                            </fo:inline>
                          </xsl:for-each>
                          <fo:leader leader-pattern="dots"/>
                        </fo:block>
                      </fo:inline-container>

                      <fo:inline-container inline-progression-dimension="19.9%" vertical-align="bottom">
                        <fo:block>
                          <fo:basic-link internal-destination="{@n}"><fo:page-number-citation letter-spacing="0" ref-id="{@n}" /></fo:basic-link>
                        </fo:block>
                      </fo:inline-container>

                    </fo:block>
                  </fo:block>
                </xsl:otherwise>
              </xsl:choose>

            </xsl:if>
          </xsl:for-each>
        </fo:flow>
      </fo:page-sequence>

      <!-- Reviewers -->
      <xsl:if test="//keywords[@n='subcategory'][1]/term[1] = 'Reviewers'">
        <fo:page-sequence master-reference="Triple" initial-page-number="1">
          <xsl:copy-of select="$header_and_footer"/>

          <fo:flow flow-name="xsl-region-body">
            <xsl:for-each select="//TEI">
              <!-- if panel. This is a lazy way to select the panels, but I wasn't too concerned with code efficiency. -->
              <xsl:if test="normalize-space(teiHeader[1]/profileDesc[1]/textClass[1]/keywords[@n='subcategory']/term[1]) = 'Reviewers'">
                <!-- Title -->
                <fo:block id="{@n}">
                  <xsl:call-template name="head"/>
                  <xsl:value-of select="teiHeader/fileDesc/titleStmt/title"/>
                  <!-- if variable is set, print ID's for proofing -->
                  <xsl:if test="$id= 'yes'">
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="@n"/>
                  </xsl:if>

                </fo:block>
                <!-- Text -->
                <xsl:for-each select="text/body/div">
                  <fo:block>
                    <xsl:call-template name="text"/>
                    <xsl:apply-templates/>
                  </fo:block>
                </xsl:for-each>
              </xsl:if>
            </xsl:for-each>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>

      <!-- Here begins the code for the three content sections: Panels, Papers, and Posters.
      There is some repeating code here, but for the sake of clarity (and me breaking it whenever
      I try and clean it up) I've left it as separate sections. -->

      <!-- ~~~~~~~~~~~~~~~~~~
      Plenary Sessions / Keynotes
      ~~~~~~~~~~~~~~~~~~~~~ -->

      <!-- Title Page -->

      <xsl:if test="//keywords[@n='subcategory']/term[1] = 'Keynote'">
        <fo:page-sequence master-reference="Single">
          <fo:flow flow-name="xsl-region-body">
            <fo:block>
              <xsl:call-template name="section_head"/>
              <xsl:text>Keynotes</xsl:text>
            </fo:block>
          </fo:flow>
        </fo:page-sequence>

        <!-- Content -->

        <fo:page-sequence master-reference="Single">
           <xsl:copy-of select="$header_and_footer"/>
           <fo:flow flow-name="xsl-region-body">
              <xsl:for-each select="//TEI">
              <!-- if panel. This is a lazy way to select the panels, but I wasn't too concerned with code efficiency. -->
              <xsl:if test="normalize-space(teiHeader[1]/profileDesc[1]/textClass[1]/keywords[@n='subcategory']/term[1]) = 'Keynote'">
                <!-- Title -->
                <fo:block id="{@n}" keep-with-next="always">
                  <xsl:call-template name="head"/>
                  <xsl:value-of select="teiHeader/fileDesc/titleStmt/title"/>
                  <!-- if variable is set, print ID's for proofing -->
                  <xsl:if test="$id= 'yes'">
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="@n"/>
                  </xsl:if>
                </fo:block>

                <!-- Authors -->
                <fo:block>
                  <xsl:call-template name="text"/>
                  <xsl:for-each select="teiHeader/fileDesc/titleStmt/author">
                    <fo:block keep-together.within-column="always">
                      <fo:block>
                        <xsl:call-template name="author_name"/>
                        <xsl:attribute name="id">
                          <xsl:value-of select="@n"></xsl:value-of>
                        </xsl:attribute>
                        <xsl:value-of select="persName/surname"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="persName/forename"/>
                      </fo:block>
                      <fo:block>
                        <xsl:call-template name="author_email"/>
                        <xsl:value-of select="email"/>
                      </fo:block>
                      <fo:block>
                        <xsl:call-template name="author_info"/>
                        <xsl:value-of select="affiliation"/>
                      </fo:block>
                    </fo:block>
                  </xsl:for-each>
                </fo:block>

                <!-- Text -->
                <xsl:for-each select="text/body/div">
                  <fo:block text-align="justify" text-align-last="left">
                    <xsl:call-template name="text"/>
                    <xsl:apply-templates/>
                  </fo:block>
                </xsl:for-each>
              </xsl:if>
            </xsl:for-each>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>

      <!-- ~~~~~~~~~~~~~~~~~~
      Workshops
      ~~~~~~~~~~~~~~~~~~~~~ -->

      <!-- Title Page -->
      <xsl:if test="//keywords[@n='subcategory']/term[1] = 'Workshop'">
        <fo:page-sequence master-reference="Single">
          <fo:flow flow-name="xsl-region-body">
            <fo:block>
              <xsl:call-template name="section_head"/>
              <xsl:text>Workshops</xsl:text>
            </fo:block>
          </fo:flow>
        </fo:page-sequence>

        <!-- Content -->

        <fo:page-sequence master-reference="Double">
          <xsl:copy-of select="$header_and_footer"/>
          <fo:flow flow-name="xsl-region-body">
            <xsl:for-each select="//TEI">
              <!-- if poster. This is a lazy way to select the panels, but I wasn't too concerned with code efficiency. -->
              <xsl:if test="normalize-space(teiHeader[1]/profileDesc[1]/textClass[1]/keywords[@n='subcategory']/term[1]) = 'Workshop'">
                <!-- Title -->
                <fo:block id="{@n}" keep-with-next="always">
                  <xsl:call-template name="head"/>
                  <xsl:value-of select="teiHeader/fileDesc/titleStmt/title"/>
                  <!-- if variable is set, print ID's for proofing -->
                  <xsl:if test="$id= 'yes'">
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="@n"/>
                  </xsl:if>
                </fo:block>

                <!-- Authors -->
                <fo:block>
                  <xsl:call-template name="text"/>
                  <xsl:for-each select="teiHeader/fileDesc/titleStmt/author">
                    <fo:block keep-together.within-column="always">
                      <fo:block>
                        <xsl:call-template name="author_name"/>
                        <xsl:attribute name="id">
                          <xsl:value-of select="@n"></xsl:value-of>
                        </xsl:attribute>
                        <xsl:value-of select="persName/surname"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="persName/forename"/>
                      </fo:block>
                      <fo:block>
                        <xsl:call-template name="author_email"/>
                        <xsl:value-of select="email"/>
                      </fo:block>
                      <fo:block>
                        <xsl:call-template name="author_info"/>
                        <xsl:value-of select="affiliation"/>
                      </fo:block>
                    </fo:block>
                  </xsl:for-each>
                </fo:block>

                <!-- Text -->
                <fo:block text-align="justify" text-align-last="left">
                  <xsl:call-template name="text"/>
                  <xsl:apply-templates select="text"/>
                </fo:block>
              </xsl:if>
            </xsl:for-each>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>

      <!-- ~~~~~~~~~~~~~~~~~~
      Panels
      ~~~~~~~~~~~~~~~~~~~~~ -->

      <!-- Title Page -->
      <xsl:if test="//keywords[@n='subcategory'][1]/term[1] = 'Panel'">
        <fo:page-sequence master-reference="Single">
          <fo:flow flow-name="xsl-region-body">
            <fo:block>
              <xsl:call-template name="section_head"/>
              <xsl:text>Panels</xsl:text>
            </fo:block>
          </fo:flow>
        </fo:page-sequence>

        <!-- Content -->

        <fo:page-sequence master-reference="Double">
          <xsl:copy-of select="$header_and_footer"/>

          <fo:flow flow-name="xsl-region-body">
            <xsl:for-each select="//TEI">
              <!-- if panel. This is a lazy way to select the panels, but I wasn't too concerned with code efficiency. -->
              <xsl:if test="normalize-space(teiHeader[1]/profileDesc[1]/textClass[1]/keywords[@n='subcategory']/term[1]) = 'Panel'">
                <!-- Title -->
                <fo:block id="{@n}" keep-with-next="always">
                  <xsl:call-template name="head"/>
                  <xsl:value-of select="teiHeader/fileDesc/titleStmt/title"/>
                  <!-- if variable is set, print ID's for proofing -->
                  <xsl:if test="$id= 'yes'">
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="@n"/>
                  </xsl:if>
                </fo:block>

                <!-- Authors -->
                <fo:block>
                  <xsl:call-template name="text"/>
                  <xsl:for-each select="teiHeader/fileDesc/titleStmt/author">
                    <fo:block keep-together.within-column="always">
                      <fo:block>
                        <xsl:call-template name="author_name"/>
                        <xsl:attribute name="id">
                          <xsl:value-of select="@n"></xsl:value-of>
                        </xsl:attribute>
                        <xsl:value-of select="persName/surname"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="persName/forename"/>
                      </fo:block>
                      <fo:block>
                        <xsl:call-template name="author_email"/>
                        <xsl:value-of select="email"/>
                      </fo:block>
                      <fo:block>
                        <xsl:call-template name="author_info"/>
                        <xsl:value-of select="affiliation"/>
                      </fo:block>
                    </fo:block>
                  </xsl:for-each>
                </fo:block>

                <!-- Text -->
                  <fo:block text-align="justify" text-align-last="left">
                    <xsl:call-template name="text"/>
                    <xsl:apply-templates select="text"/>
                  </fo:block>
              </xsl:if>
            </xsl:for-each>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>

      <!-- ~~~~~~~~~~~~~~~~~~
      Sektionen
      ~~~~~~~~~~~~~~~~~~~~~ -->

      <!-- Title Page -->

      <xsl:if test="//keywords[@n='subcategory']/term[1] = 'Sektion'">
        <fo:page-sequence master-reference="Single">
          <fo:flow flow-name="xsl-region-body">
            <fo:block>
              <xsl:call-template name="section_head"/>
              <xsl:text>Sektionen</xsl:text>
            </fo:block>
          </fo:flow>
        </fo:page-sequence>

        <!-- Content -->

        <fo:page-sequence master-reference="Double">
          <xsl:copy-of select="$header_and_footer"/>
          <fo:flow flow-name="xsl-region-body">
            <xsl:for-each select="//TEI">
              <!-- if paper. This is a lazy way to select the panels, but I wasn't too concerned with code efficiency. -->
              <xsl:if test="normalize-space(teiHeader[1]/profileDesc[1]/textClass[1]/keywords[@n='subcategory']/term[1]) = 'Sektion'">
                <!-- Title -->
                <fo:block id="{@n}" keep-with-next="always">
                  <xsl:call-template name="head"/>
                  <xsl:value-of select="teiHeader/fileDesc/titleStmt/title"/>
                  <!-- if variable is set, print ID's for proofing -->
                  <xsl:if test="$id= 'yes'">
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="@n"/>
                  </xsl:if>
                </fo:block>

                <!-- Authors -->
                <fo:block>
                  <xsl:call-template name="text"/>
                  <xsl:for-each select="teiHeader/fileDesc/titleStmt/author">
                    <fo:block keep-together.within-column="always">
                      <fo:block>
                        <xsl:call-template name="author_name"/>
                        <xsl:attribute name="id">
                          <xsl:value-of select="@n"></xsl:value-of>
                        </xsl:attribute>
                        <xsl:value-of select="persName/surname"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="persName/forename"/>
                      </fo:block>
                      <fo:block>
                        <xsl:call-template name="author_email"/>
                        <xsl:value-of select="email"/>
                      </fo:block>
                      <fo:block>
                        <xsl:call-template name="author_info"/>
                        <xsl:value-of select="affiliation"/>
                      </fo:block>
                    </fo:block>
                  </xsl:for-each>
                </fo:block>

                <!-- Text -->
                <fo:block text-align="justify" text-align-last="left">
                  <xsl:call-template name="text"/>
                  <xsl:apply-templates select="text"/>
                </fo:block>
              </xsl:if>
            </xsl:for-each>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>

      <!-- ~~~~~~~~~~~~~~~~~~
      Vorträge
      ~~~~~~~~~~~~~~~~~~~~~ -->

      <!-- Title Page -->
      <xsl:if test="//keywords[@n='subcategory']/term[1] = 'Vortrag'">
        <fo:page-sequence master-reference="Single">
          <fo:flow flow-name="xsl-region-body">
            <fo:block>
              <xsl:call-template name="section_head"/>
              <xsl:text>Vorträge</xsl:text>
            </fo:block>
          </fo:flow>
        </fo:page-sequence>

        <!-- Content -->

        <fo:page-sequence master-reference="Double">
          <xsl:copy-of select="$header_and_footer"/>
          <fo:flow flow-name="xsl-region-body">
            <xsl:for-each select="//TEI">
              <!-- if Vortrag. This is a lazy way to select the panels, but I wasn't too concerned with code efficiency. -->
              <xsl:if test="normalize-space(teiHeader[1]/profileDesc[1]/textClass[1]/keywords[@n='subcategory']/term[1]) = 'Vortrag'">
                <!-- Title -->
                <fo:block id="{@n}" keep-with-next="always">
                  <xsl:call-template name="head"/>
                  <xsl:value-of select="teiHeader/fileDesc/titleStmt/title"/>
                  <xsl:apply-templates select="hi"/>
                  <!-- if variable is set, print ID's for proofing -->
                  <xsl:if test="$id= 'yes'">
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="@n"/>
                  </xsl:if>
                </fo:block>

                <!-- Authors -->
                <fo:block>
                  <xsl:call-template name="text"/>
                  <xsl:for-each select="teiHeader/fileDesc/titleStmt/author">
                    <fo:block keep-together.within-column="always">
                      <fo:block>
                        <xsl:call-template name="author_name"/>
                        <xsl:attribute name="id">
                          <xsl:value-of select="@n"></xsl:value-of>
                        </xsl:attribute>
                        <xsl:value-of select="persName/surname"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="persName/forename"/>
                      </fo:block>
                      <fo:block>
                        <xsl:call-template name="author_email"/>
                        <xsl:value-of select="email"/>
                      </fo:block>
                      <fo:block>
                        <xsl:call-template name="author_info"/>
                        <xsl:value-of select="affiliation"/>
                      </fo:block>
                    </fo:block>
                  </xsl:for-each>
                </fo:block>

                <!-- Text -->
                <fo:block text-align="justify" text-align-last="left">
                  <xsl:call-template name="text"/>
                  <xsl:apply-templates select="text"/>
                </fo:block>
              </xsl:if>
            </xsl:for-each>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>

      <!-- ~~~~~~~~~~~~~~~~~~
      Poster
      ~~~~~~~~~~~~~~~~~~~~~ -->

      <!-- Title Page -->
      <xsl:if test="//keywords[@n='subcategory']/term[1] = 'Poster'">
        <fo:page-sequence master-reference="Single">
          <fo:flow flow-name="xsl-region-body">
            <fo:block>
              <xsl:call-template name="section_head"/>
              <xsl:text>Poster</xsl:text>
            </fo:block>
          </fo:flow>
        </fo:page-sequence>

        <!-- Content -->

        <fo:page-sequence master-reference="Double">
          <xsl:copy-of select="$header_and_footer"/>
          <fo:flow flow-name="xsl-region-body">
            <xsl:for-each select="//TEI">
              <!-- if poster. This is a lazy way to select the panels, but I wasn't too concerned with code efficiency. -->
              <xsl:if test="normalize-space(teiHeader[1]/profileDesc[1]/textClass[1]/keywords[@n='subcategory']/term[1]) = 'Poster'">
                <!-- Title -->
                <fo:block id="{@n}" keep-with-next="always">
                  <xsl:call-template name="head"/>
                  <xsl:value-of select="teiHeader/fileDesc/titleStmt/title"/>
                  <!-- if variable is set, print ID's for proofing -->
                  <xsl:if test="$id= 'yes'">
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="@n"/>
                  </xsl:if>
                </fo:block>

                <!-- Authors -->
                <fo:block>
                  <xsl:call-template name="text"/>
                  <xsl:for-each select="teiHeader/fileDesc/titleStmt/author">
                    <fo:block keep-together.within-column="always">
                      <fo:block>
                        <xsl:call-template name="author_name"/>
                        <xsl:attribute name="id">
                          <xsl:value-of select="@n"></xsl:value-of>
                        </xsl:attribute>
                        <xsl:value-of select="persName/surname"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="persName/forename"/>
                      </fo:block>
                      <fo:block>
                        <xsl:call-template name="author_email"/>
                        <xsl:value-of select="email"/>
                      </fo:block>
                      <fo:block>
                        <xsl:call-template name="author_info"/>
                        <xsl:value-of select="affiliation"/>
                      </fo:block>
                    </fo:block>
                  </xsl:for-each>
                </fo:block>

                <!-- Text -->
                <fo:block text-align="justify" text-align-last="left">
                  <xsl:call-template name="text"/>
                  <xsl:apply-templates select="text"/>
                </fo:block>
              </xsl:if>
            </xsl:for-each>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>

      <!-- Autorinnen -->
      <fo:page-sequence master-reference="Double">
        <fo:flow flow-name="xsl-region-body">
          <fo:block>
            <xsl:call-template name="head"/>
            <xsl:text>Index der Autorinnen und Autoren</xsl:text>
          </fo:block>

          <xsl:for-each-group group-by="." select="//TEI/teiHeader/fileDesc/titleStmt/author/persName/@n">
            <xsl:sort select="."/>

            <fo:block text-align-last="justify">
              <xsl:call-template name="text"/>
              <xsl:value-of select="parent::persName"/><xsl:text> </xsl:text>
              <fo:leader leader-pattern="dots"/>
              <xsl:for-each select="current-group()">
                <fo:basic-link internal-destination="{parent::persName/parent::author/@n}">
                  <xsl:text> </xsl:text>
                  <fo:page-number-citation ref-id="{parent::persName/parent::author/@n}"/>
                  <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
                </fo:basic-link>
              </xsl:for-each>
            </fo:block>
          </xsl:for-each-group>
        </fo:flow>
      </fo:page-sequence>

      <!-- End image -->

      <xsl:if test="$output = 'pdf'">
        <fo:page-sequence master-reference="Full">
          <fo:flow flow-name="xsl-region-body">
            <fo:block>
              <fo:external-graphic src="../../../input/images/back_cover.jpg" content-height="297mm" content-width="210mm"/>
            </fo:block>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>


    </fo:root>

  </xsl:template>


  <!-- =================================================================================
  Individual style templates for TEI
  ================================================================================= -->

  <xsl:template match="p">
    <xsl:choose>
      <!-- Special formatting for intro. Verbose becasue I can't use a variable to select an attribute set. -->
      <xsl:when test="@n='text'">
        <fo:block>
          <xsl:call-template name="plain_text"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="parent::div[@type='intro_material']">
        <fo:block>
          <xsl:call-template name="intro_text"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="@n='intro_text'">
        <fo:block>
          <xsl:call-template name="intro_text"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="@n='intro_text_center'">
        <fo:block>
          <xsl:call-template name="intro_text_center"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="@n='intro_text_italic'">
        <fo:block>
          <xsl:call-template name="intro_text_italic"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="@n='intro_text_italic_center'">
        <fo:block>
          <xsl:call-template name="intro_text_italic_center"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <!-- When p is inside a list, to handle double indents -->
      <xsl:when test="ancestor::list">
        <fo:block>
          <xsl:call-template name="p_inlist"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="ancestor::figure">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <xsl:call-template name="p"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="head">
    <xsl:choose>
      <!-- First sets are for intro materials, where author style is a bit different -->
      <xsl:when test="@n='intro_head_large_center'">
        <fo:block>
          <xsl:call-template name="intro_head_large_center"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="@n='intro_head_medium_center'">
        <fo:block>
          <xsl:call-template name="intro_head_medium_center"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="@n='intro_head_medium_italic_center'">
        <fo:block>
          <xsl:call-template name="intro_head_medium_italic_center"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="@n='intro_head_small'">
        <fo:block>
          <xsl:call-template name="intro_head_small"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>

      <xsl:when test="@type='author'">
        <fo:block>
          <xsl:call-template name="author_name"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="@type='email'">
        <fo:block>
          <xsl:call-template name="author_email"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="@type='title'">
        <fo:block>
          <xsl:call-template name="author_info"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <!-- other special headers -->
      <xsl:when test="@type='section_head'">
        <fo:block>
          <xsl:call-template name="section_head"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="@type='main'">
        <fo:block>
          <xsl:call-template name="subhead"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="@type='sub'">
        <fo:block>
          <xsl:call-template name="subsubsubhead"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="@type='authors'">
        <fo:block>
          <xsl:call-template name="subsubhead"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="ancestor::figure">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <fo:block keep-with-next="always"  text-align="left">
          <xsl:call-template name="subsubhead"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="lb">
    <fo:block></fo:block>
  </xsl:template>

  <xsl:template match="list">
    <fo:list-block>
      <xsl:call-template name="list"/>
      <xsl:if test="not(ancestor::list)"><xsl:call-template name="list_margins"/></xsl:if>
      <xsl:apply-templates/>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="item">
    <fo:list-item>
      <fo:list-item-label>
        <xsl:call-template name="list_item_label"/>
        <xsl:choose>
          <xsl:when test="parent::list/@type='simple' or parent::list/@type='ordered'">
            <fo:block></fo:block>
          </xsl:when>
          <xsl:when test="parent::list/@type='unordered'">
            <fo:block></fo:block>
          </xsl:when>
          <xsl:otherwise>
            <fo:block></fo:block>
          </xsl:otherwise>
        </xsl:choose>
      </fo:list-item-label>
      <fo:list-item-body>
        <xsl:call-template name="list-item-body"/>
        <fo:block text-align="left">
          <xsl:if test="parent::list/@type='unordered'">
            <xsl:text>•&#160;&#160;&#160;</xsl:text>
          </xsl:if>
          <xsl:if test="parent::list/@type='ordered'">
            <xsl:number/><xsl:text>.&#160;&#160;</xsl:text>
          </xsl:if>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="ref">
    <xsl:choose>
      <xsl:when test="starts-with(@target, 'ftn')">
        <fo:inline><xsl:call-template name="superscript"/>
          <xsl:value-of select="@n"/>
          <xsl:text></xsl:text>
        <xsl:apply-templates/>
        <xsl:text></xsl:text></fo:inline>
      </xsl:when>
      <xsl:when test="starts-with(@target, 'http')">
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="@type='url'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ptr">
    <xsl:choose>
      <xsl:when test="starts-with(@target, 'ftn')">
        <fo:inline><xsl:call-template name="superscript"/>
          <xsl:value-of select="@n"/>
          <xsl:text></xsl:text>
          <xsl:apply-templates/>
          <xsl:text></xsl:text></fo:inline>
      </xsl:when>
      <xsl:when test="starts-with(@target, 'http')">
        <xsl:text> </xsl:text>
        <xsl:value-of select="@target"></xsl:value-of>
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="@type='url'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="back">
    <fo:block>
      <xsl:call-template name="back"/><xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="bibl">
    <fo:block>
      <xsl:call-template name="p"/><xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- DIV's -->

  <xsl:template match="div[@type='References'] | div[@type='references']">
    <fo:block><xsl:call-template name="subsubhead"/>References</fo:block>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="div[@type='Notes'] | div[@type='notes']">
    <fo:block keep-with-next="always"><xsl:call-template name="subsubhead"/>Fu&#223;noten</fo:block>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="div[@n='nobreak']">
    <fo:block page-break-inside="avoid"><xsl:apply-templates/></fo:block>
  </xsl:template>

  <xsl:template match="div[@n='publisher_info']">
    <fo:block><xsl:call-template name="publisher_info"/><xsl:apply-templates/></fo:block>
  </xsl:template>

  <!-- Notes -->

  <xsl:template match="note">
    <xsl:choose>
      <!-- numbered end notes -->
      <xsl:when test="@n">
        <fo:block text-align="left">
          <xsl:call-template name="text"/>
          <xsl:value-of select="@n"/><xsl:text>. </xsl:text><xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block ><xsl:call-template name="text"/><xsl:apply-templates/></fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="hi">
    <xsl:choose>
      <xsl:when test="@rend='italic'">
        <fo:inline><xsl:call-template name="italic"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <xsl:when test="@rend='bold'">
        <fo:inline><xsl:call-template name="bold"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <xsl:when test="@rend='underline'">
        <fo:inline><xsl:call-template name="underline"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <xsl:when test="@rend='smallcaps'">
        <fo:inline><xsl:call-template name="smallcaps"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <xsl:when test="@rend='superscript'">
        <fo:inline><xsl:call-template name="superscript"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <xsl:when test="@rend='superscript' or @rend='super' or @rend='sup'">
        <fo:inline><xsl:call-template name="superscript"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <xsl:when test="@rend='subscript' or @rend='sub'">
        <fo:inline><xsl:call-template name="subscript"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <!-- Languages -->
      <xsl:when test="@rend='Hebrew'">
        <fo:inline><xsl:call-template name="hebrew"/><xsl:text> </xsl:text><xsl:apply-templates/><xsl:text> </xsl:text></fo:inline>
      </xsl:when>
      <xsl:when test="@rend='Chinese'">
        <fo:inline><xsl:call-template name="chinese"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <xsl:when test="@rend='Ethiopic'">
        <fo:inline><xsl:call-template name="ethiopic"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <xsl:when test="@rend='Japanese'">
        <fo:inline ><xsl:call-template name="japanese"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <xsl:when test="@rend='math'">
        <fo:inline ><xsl:call-template name="math"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <xsl:when test="@rend='fraction'">
        <fo:inline ><xsl:call-template name="fraction"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <xsl:when test="@rend='math_alt_font'">
        <fo:inline ><xsl:call-template name="math_alt_font"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <xsl:when test="@rend='sameline'"><!-- Wed, 22 Jun 2016 10:47:14 +0200 moocow: suppress line breaks (e.g. in formulae) -->
        <fo:inline ><xsl:call-template name="sameline"/><xsl:apply-templates/></fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="hi[@rend='under']" />
  <xsl:template match="hi[@rend='over']" />


  <xsl:template match="figure">
    <xsl:choose>
      <xsl:when test="graphic/@n='intro'">
        <fo:block>
          <xsl:call-template name="figure_container_intro"/>
          <fo:external-graphic>
            <xsl:attribute name="src"><xsl:text>../../../input/images/</xsl:text><xsl:value-of select="graphic/@url"/></xsl:attribute>
            <xsl:call-template name="figure_intro"/>
          </fo:external-graphic>

        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <xsl:call-template name="figure_container"/>
          <fo:external-graphic>
            <xsl:attribute name="src"><xsl:text>../../../input/images/</xsl:text><xsl:value-of select="graphic/@url"/></xsl:attribute>
            <xsl:call-template name="figure"/>
          </fo:external-graphic>
          <fo:block text-align="left"><xsl:call-template name="figure_head"/><xsl:apply-templates select="head"/></fo:block>
          <fo:block text-align="left"><xsl:call-template name="figure_p"/><xsl:apply-templates select="p"/></fo:block>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>


  </xsl:template>
  <xsl:template match="code">
    <fo:inline><xsl:call-template name="code"/><xsl:apply-templates/></fo:inline>
  </xsl:template>


  <xsl:template match="table">
    <xsl:for-each select="head">
      <fo:block>
        <xsl:call-template name="subsubhead"/><xsl:apply-templates select="."/></fo:block>
      </xsl:for-each>

      <fo:table>
        <xsl:choose>
          <xsl:when test="@n='text_smaller'">
            <xsl:call-template name="table_smaller"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="table"/>
          </xsl:otherwise>
        </xsl:choose>
        <fo:table-body>
          <xsl:for-each select="row">
            <fo:table-row>
              <xsl:for-each select="cell">
                <fo:table-cell><xsl:call-template name="cell"/>
                  <fo:block text-align="left">
                  <xsl:if test="ancestor::table[@n='text_smaller']"><xsl:call-template name="text_smaller"/></xsl:if>
                  <xsl:apply-templates select="."/>
                </fo:block>
              </fo:table-cell>
            </xsl:for-each>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>

  </xsl:template>

  <xsl:template match="quote">
    <fo:block><xsl:call-template name="blockquote"/><!--<xsl:text>“</xsl:text>--><xsl:apply-templates/><!--<xsl:text>”</xsl:text>--></fo:block>
  </xsl:template>

  <xsl:template match="cit">
    <fo:block><xsl:call-template name="blockquote"/><!--<xsl:text>“</xsl:text>--><xsl:apply-templates/><!--<xsl:text>”</xsl:text>--></fo:block>
  </xsl:template>

  <xsl:template match="lg">
    <fo:block><xsl:call-template name="line-group"/><xsl:apply-templates/></fo:block>
  </xsl:template>

  <xsl:template match="l">
    <fo:block><xsl:call-template name="plain-block"/><xsl:apply-templates/></fo:block>
  </xsl:template>

  <xsl:template match="seg[@n='ISBN']">
    <xsl:choose>
      <xsl:when test="$output = 'print'">
        <xsl:text>ISBN 978-3-941379-05-3</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>ISBN 978-3-941379-05-3</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="seg[@n='book_figure']">
    <xsl:choose>
      <xsl:when test="$output = 'print'">
        <fo:block>
          <xsl:call-template name="figure_container_intro"/>
          <fo:external-graphic>
            <xsl:attribute name="src"><xsl:text>../../../input/images/logo_bw.jpg</xsl:text></xsl:attribute>
            <xsl:call-template name="figure_intro"/>
          </fo:external-graphic>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <xsl:call-template name="figure_container_intro"/>
          <fo:external-graphic>
            <xsl:attribute name="src"><xsl:text>../../../input/images/logo_color.jpg</xsl:text></xsl:attribute>
            <xsl:call-template name="figure_intro"/>
          </fo:external-graphic>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
