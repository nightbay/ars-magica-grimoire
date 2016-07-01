<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:java="http://xml.apache.org/xslt/java"
  exclude-result-prefixes="java" xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:param name="single" select="''"/>
  <xsl:param name="edit" select="''"/>
  <xsl:param name="spellsonly" select="'false'"/>
  <xsl:param name="cover" select="'true'"/>

  <xsl:output method="xml" indent="yes" />
  
  <xsl:variable name="in" select="/" />
  <xsl:variable name="handcolour">#2B1B09</xsl:variable>
  <xsl:variable name="Creo">#FFFFF0</xsl:variable> <!-- white --> 
  <xsl:variable name="Intellego">#FFD700</xsl:variable> <!-- gold -->
  <xsl:variable name="Muto">#F0E68C</xsl:variable> <!-- constantly fluctuating -->
  <xsl:variable name="Perdo">#000000</xsl:variable> <!-- black -->
  <xsl:variable name="Rego">#800080</xsl:variable> <!-- purple -->
  <xsl:variable name="Animal">#8B4513</xsl:variable> <!-- brown -->
  <xsl:variable name="Aquam">#000080</xsl:variable> <!-- blue -->
  <xsl:variable name="Auram">#EE82EE</xsl:variable> <!-- violet -->
  <xsl:variable name="Corpus">#8B0000</xsl:variable> <!-- dark red -->
  <xsl:variable name="Herbam">#006400</xsl:variable> <!-- green -->
  <xsl:variable name="Imaginem">#ADD8E6</xsl:variable> <!-- pearly blue -->
  <xsl:variable name="Ignem">#DC143C</xsl:variable> <!-- bright red -->
  <xsl:variable name="Mentem">#FF8C000</xsl:variable> <!-- orange -->
  <xsl:variable name="Terram">#583933</xsl:variable> <!-- dark brown -->
  <xsl:variable name="Vim">#C0C0C0</xsl:variable> <!-- silver --> 
  <xsl:variable name="artfont">Lombardy MC</xsl:variable>
  <xsl:variable name="handfont">Asphyxiate</xsl:variable>
  <xsl:variable name="sigfont">Asphyxiate</xsl:variable>
  <xsl:variable name="textfont">Calibri</xsl:variable>
  
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$single = ''"><xsl:call-template name="book"/></xsl:when>
      <xsl:otherwise><xsl:call-template name="singleform"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="book">
    <fo:root>
      <fo:layout-master-set>

        <fo:simple-page-master master-name="inner-leaf" page-height="11in" page-width="8.5in" margin="2cm" margin-right="8cm">
          <fo:region-body margin-bottom="0.5in" margin-top="1in" />
          <fo:region-before region-name="xsl-region-before"
            extent=".5in" />
          <fo:region-after region-name="xsl-region-after"
            extent=".25in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="form-notes" page-height="11in" page-width="8.5in" margin="0cm">
          <fo:region-body margin-bottom="0in" margin-right="2.8cm" margin-left="3.6cm" margin-top="4cm" />
          <fo:region-before region-name="xsl-region-before" margin-top="0in" extent="3in" />
          <fo:region-after region-name="xsl-region-after" extent=".5in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="arts-guideline" page-height="11in" page-width="8.5in" margin="0cm">
          <fo:region-body margin-bottom="1cm" margin-left="1.5cm" margin-right="2cm" margin-top="1.1in" />
          <fo:region-before region-name="xsl-region-before" extent="1.5in" />
          <fo:region-after region-name="xsl-region-after" extent=".5in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="spell-list" page-height="11in" page-width="8.5in" margin="0cm">
          <fo:region-body column-count="2" margin-bottom="0.5in"  margin-top="0.5in" margin-left="2cm" margin-right="2cm"/>
          <fo:region-before region-name="xsl-region-before" extent=".5in" />
          <fo:region-after region-name="xsl-region-after" extent=".5in" margin-right="2cm"/>
        </fo:simple-page-master>
        
      </fo:layout-master-set>

      <!-- Cover page -->
      <xsl:if test="$cover = 'true'">
        <fo:page-sequence master-reference="inner-leaf">
          <xsl:if test="$edit = ''">
            <fo:static-content flow-name="xsl-region-before">
              <fo:block-container absolute-position="absolute"
                top="-3.5cm" left="-2cm" width="8.5in" height="11.8in"
                background-image="images/leaflet.jpg">
                <fo:block />
              </fo:block-container>
            </fo:static-content>
          </xsl:if>
          <fo:static-content flow-name="xsl-region-after"><fo:block></fo:block></fo:static-content>
          <fo:flow flow-name="xsl-region-body">
            <fo:block color="{$handcolour}" font-family="{$handfont}" font-size="24pt">Most Learned Companion,</fo:block>
            <fo:block color="{$handcolour}" font-family="{$handfont}" font-size="18pt">
            Contained here-in are all of the known enchantments of Fractured Magic, recorded without prejudice or bias. 
            Many sources, both illustrious and wondrous, were exhaustively studied to author the compendium you now hold in your venerable hands. 
            Enumeration of all prestigious references consulted in the transcription of these enchantments would require a tome as mighty as this one. 
            I would be amiss, though, not to mention references that were more valuable than most: <fo:inline font-family="Lauren C. Brown" font-size="10pt"> Ars Magica (<xsl:value-of select="count($in/ars_magica/spells/spell[not(@source)])"/> spells),</fo:inline>
            <xsl:for-each select="ars_magica/books/book">
              <xsl:sort select="name"/>
              <xsl:variable name="abbrev" select="abbreviation"/>
              <xsl:if test="position() = last()"><xsl:text> </xsl:text>and </xsl:if><fo:inline font-family="Lauren C. Brown" font-size="10pt"><xsl:value-of select="name" /><xsl:text> </xsl:text>(<xsl:value-of select="abbreviation" />, <xsl:value-of select="count($in/ars_magica/spells/spell[@source=$abbrev])"/> spells)<xsl:if test="position() &lt; last()">,</xsl:if></fo:inline>
            </xsl:for-each>.
            </fo:block>
            <fo:block font-family="{$handfont}" color="#661A1A" font-size="48pt">N'Allette</fo:block>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>
    
      <!--  Each form/technique pair  -->
      <xsl:for-each select="/ars_magica/arts/form/name">
        <xsl:variable name="form" select="."/>
        <xsl:call-template name="form-notes">
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
          
        <xsl:for-each select="/ars_magica/arts/technique/name">
          <xsl:variable name="technique" select="."/>
          <xsl:call-template name="art-guidelines">
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="technique" select="$technique"/>
          </xsl:call-template>

          <xsl:call-template name="spellblock">
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="technique" select="$technique"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>
    </fo:root>
  </xsl:template>

  <xsl:template name="singleform">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="form-notes" page-height="11in" page-width="8.5in" margin="0cm">
          <fo:region-body margin-bottom="0in" margin-right="2.8cm" margin-left="3.6cm" margin-top="4cm" />
          <fo:region-before region-name="xsl-region-before" margin-top="0in" extent="3in" />
          <fo:region-after region-name="xsl-region-after" extent=".25in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="arts-guideline" page-height="11in" page-width="8.5in" margin="0cm">
          <fo:region-body margin-bottom="1cm" margin-left="3.5cm" margin-right="2.8cm" margin-top="2in" />
          <fo:region-before region-name="xsl-region-before" extent="3in" />
          <fo:region-after region-name="xsl-region-after" extent=".25in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="spell-list" page-height="11in" page-width="8.5in" margin="0cm">
          <fo:region-body column-count="2" margin-bottom="0.5in"  margin-top="0.5in" margin-left="2cm" margin-right="2cm"/>
          <fo:region-before region-name="xsl-region-before" extent=".8in" />
          <fo:region-after region-name="xsl-region-after" extent=".25in" />
        </fo:simple-page-master>
      </fo:layout-master-set>
    
        <xsl:call-template name="form-notes">
          <xsl:with-param name="form" select="$single"/>
        </xsl:call-template>
          
      <xsl:for-each select="/ars_magica/arts/technique/name">
        <xsl:variable name="technique" select="."/>
        <xsl:call-template name="art-guidelines">
          <xsl:with-param name="form" select="$single"/>
          <xsl:with-param name="technique" select="$technique"/>
        </xsl:call-template>

        <xsl:call-template name="spellblock">
          <xsl:with-param name="form" select="$single"/>
          <xsl:with-param name="technique" select="$technique"/>
        </xsl:call-template>
      </xsl:for-each>
    </fo:root>
  </xsl:template>

  <xsl:template name="form-notes">
    <xsl:param name="form"/>
    <xsl:variable name="color"><xsl:value-of select="/ars_magica/arts/form[name=$form]/color"/></xsl:variable>

    <fo:page-sequence master-reference="form-notes">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="8.5in" height="11.8in" background-image="images/form2.jpg">
            <fo:block />
          </fo:block-container>
        </xsl:if>
        <fo:block margin-top="3cm" text-align="center" color="{$color}" text-transform="capitalize" font-family="{$artfont}" font-size="24pt" font-weight="normal">
          <xsl:value-of select="$form"/>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after"><fo:block></fo:block></fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:block></fo:block>
        <xsl:apply-templates select="/ars_magica/arts/form[name = $form]/description/p" mode="notes"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template match="text()"><xsl:copy/></xsl:template>

  <xsl:template match="strong"><fo:inline font-weight="bold"><xsl:value-of select="."/></fo:inline></xsl:template>

  <xsl:template match="p" mode="notes"><fo:block color="{$handcolour}" space-before="2.5pt" text-indent="1em" font-size="9pt"><xsl:apply-templates/></fo:block></xsl:template>

  <xsl:template match="p" mode="guideline"><fo:block color="{$handcolour}" space-before="2.5pt" text-indent="1em" font-size="9pt"><xsl:apply-templates/></fo:block></xsl:template>
    
  <xsl:template name="art-guidelines">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
      <xsl:variable name="fcolor"><xsl:value-of select="/ars_magica/arts/form[name=$form]/color"/></xsl:variable>
      <xsl:variable name="tcolor"><xsl:value-of select="/ars_magica/arts/technique[name=$technique]/color"/></xsl:variable>

    <fo:page-sequence master-reference="arts-guideline">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="8.5in" height="11.8in" background-image="images/backdrop3.jpg">
            <fo:block />
          </fo:block-container>
        </xsl:if>
        <fo:block margin-top=".75in" text-align="center" color="{$handcolour}" font-family="{$artfont}" font-size="18pt" font-weight="normal">
          <xsl:value-of select="$technique"/><xsl:text> </xsl:text><xsl:value-of select="$form"/>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after"><fo:block></fo:block></fo:static-content>
      <fo:flow flow-name="xsl-region-body"><fo:block></fo:block>
        <xsl:apply-templates select="/ars_magica/arts_guidelines/arts_guideline[arts/form=$form and arts/technique=$technique]/description/p" mode="guideline"/>
        <fo:block space-before="3pt" font-size="8pt"><xsl:text> </xsl:text></fo:block>
        <xsl:if test="count(/ars_magica/arts_guidelines/arts_guideline[arts/form=$form and arts/technique=$technique]/guidelines/guideline) &gt; 0">
          <fo:table>
            <fo:table-body>
              <xsl:for-each select="/ars_magica/arts_guidelines/arts_guideline[arts/form=$form and arts/technique=$technique]/guidelines/guideline">
                <fo:table-row table-layout="fixed">
                  <fo:table-cell width="4.2em">
                    <fo:block font-size="8pt">
                      <xsl:if test="not(preceding-sibling::*[1]/level = level)">
                        <xsl:if test="level != 'General'">Level </xsl:if><xsl:value-of select="level"/>
                      </xsl:if>
                    </fo:block>
                  </fo:table-cell>    
                  <fo:table-cell>
                    <fo:block text-indent="-1em" font-size="8pt">
                      <xsl:if test="@mystery='true'"><fo:inline font-style="italic">Mystery </fo:inline></xsl:if>
                      <xsl:if test="@ritual='true'"><fo:inline font-style="italic">Ritual </fo:inline></xsl:if>
                      <xsl:if test="@faerie='true'"><fo:inline font-style="italic">Faerie </fo:inline></xsl:if>
                      <xsl:value-of select="description"/><xsl:call-template name="source"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:for-each>
            </fo:table-body>
          </fo:table>
        </xsl:if>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template name="spellblock">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
    <fo:page-sequence master-reference="spell-list">
    <fo:static-content flow-name="xsl-region-before">
      <xsl:if test="$edit = ''">
        <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="8.5in" height="11.8in"
          background-image="images/paper2.jpg">
          <fo:block />
        </fo:block-container>
      </xsl:if>

      <fo:block>
        <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
          <fo:block></fo:block>
        </fo:inline-container>
        <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
          <fo:block></fo:block>
        </fo:inline-container>
      </fo:block>
    </fo:static-content>
    <fo:static-content flow-name="xsl-region-after">
      <fo:block color="{$handcolour}" text-align="right" font-family="Calibri" font-size="8pt" font-weight="normal" margin-right="2cm">
        <xsl:value-of select="$technique"/><xsl:text> </xsl:text><xsl:value-of select="$form"/>
      </fo:block>
    </fo:static-content>
    <fo:flow flow-name="xsl-region-body">
        <xsl:variable name="color"><xsl:value-of select="/ars_magica/arts/form[name=$form]/color"/></xsl:variable>
      <fo:block color="{$color}" text-transform="capitalize"
        font-family="{$artfont}" font-size="12pt" margin-bottom="8px" font-weight="normal"><xsl:value-of select="$technique"/><xsl:text> </xsl:text><xsl:value-of select="$form"/> Spells</fo:block>
          <xsl:variable name="generalspells" select="$in/ars_magica/spells/spell[arts/technique=$technique and arts/form=$form and level='GENERAL']"/>
          <xsl:variable name="spells" select="$in/ars_magica/spells/spell[arts/technique=$technique and arts/form=$form and level != 'GENERAL']"/>
      <xsl:variable name="levels" select="distinct-values($spells/level)"/>

      <xsl:if test="count($generalspells) &gt; 0">
        <fo:block keep-with-next.within-page="always" font-size="9pt" font-family="Calibri" margin-bottom="0.2em">GENERAL</fo:block>
        <xsl:call-template name="spells-at-level">
              <xsl:with-param name="form" select="$form"/>
          <xsl:with-param name="technique" select="$technique"/>
          <xsl:with-param name="level" select="'GENERAL'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:for-each select="$levels">
          <xsl:sort select="." data-type="number"/>
        <xsl:variable name="slevel" select="."/>
        <fo:block keep-with-next.within-page="always" font-size="9pt" font-family="Calibri" margin-bottom="0.2em">LEVEL <xsl:value-of select="$slevel"/></fo:block>
        <xsl:call-template name="spells-at-level">
          <xsl:with-param name="form" select="$form"/>
          <xsl:with-param name="technique" select="$technique"/>
          <xsl:with-param name="level" select="$slevel"/>
        </xsl:call-template>
      </xsl:for-each>
    </fo:flow>
  </fo:page-sequence>
    
  </xsl:template>

  <xsl:template match="requisite" mode="guideline">
    , <xsl:choose>
        <xsl:when test="@free = 'true'"><xsl:value-of select="." /> requisite free</xsl:when>
        <xsl:otherwise>+1 <xsl:value-of select="." /> requisite</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="requisite">
    <xsl:value-of select="." /><xsl:if test="position() &lt; last()">, </xsl:if>
  </xsl:template>

  <xsl:template name="spells-at-level">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
    <xsl:param name="level"/>
    <xsl:for-each select="$in/ars_magica/spells/spell[arts/technique=$technique and arts/form=$form and level=$level]">
      <fo:block page-break-inside="avoid">
        <fo:block font-family="Calibri" font-size="9pt" font-weight="normal">
          <fo:inline text-transform="capitalize"><xsl:value-of select="name" /></fo:inline><xsl:call-template name="source"/>
        </fo:block>
        <fo:block font-family="Calibri" text-indent="1em" font-size="8pt" font-weight="normal">
          R: <xsl:apply-templates select="range" />, D: <xsl:apply-templates select="duration" />, T: <xsl:value-of select="target" />
          <xsl:if test="@type='mystery'">, Mystery</xsl:if>
          <xsl:if test="@ritual='true'">, Ritual</xsl:if>
          <xsl:if test="@faerie='true'">, Faerie</xsl:if>
        </fo:block>
        <xsl:if test="count(requisite) &gt; 0">
          <fo:block font-family="Calibri" text-indent="1em" font-size="8pt">Requisite: <xsl:apply-templates select="requisite"><xsl:sort select="."/></xsl:apply-templates></fo:block>
        </xsl:if>
        <xsl:apply-templates select="description"/>
        <fo:block margin-bottom="2mm" font-family="Calibri"
          font-size="7pt" font-style="italic" font-weight="normal">
          <xsl:choose>
            <xsl:when test="@type = 'standard' or @type = 'mystery'">
              <xsl:choose>
                <xsl:when test="guideline/@ward = 'true'">(As ward guideline)</xsl:when>
                <xsl:otherwise>(Base <xsl:value-of select="guideline/base" /> <xsl:call-template name="spell-guidelines" />
                <xsl:apply-templates select="requisite" mode="guideline"/>)</xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="@type = 'general'">(Base effect)</xsl:when>
            <xsl:when test="@type = 'unique'">(Unique spell)</xsl:when>
            <xsl:when test="@type = 'mercurian'">(Mercurian Ritual)</xsl:when>
            <xsl:when test="@type = 'special'">(Special spell)</xsl:when>
            <xsl:otherwise>
              ERROR
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:block>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="p">
    <fo:block text-indent="1em" font-family="Calibri" font-size="8pt" font-weight="normal"><xsl:apply-templates/></fo:block>
  </xsl:template>

  <xsl:template match="reference"><fo:inline font-style="italic"><xsl:value-of select="."/></fo:inline>
    <xsl:choose>
      <xsl:when test="@page != ''">, page <xsl:value-of select="@page"/></xsl:when>
      <xsl:when test="@chapter != ''">, chapter <xsl:value-of select="@chapter"/></xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="flavour">
    <fo:block text-indent="1em" font-family="Calibri" font-size="8pt" font-weight="normal" font-style="italic"><xsl:value-of select="." /></fo:block>
  </xsl:template>

  <xsl:template name="spell-guidelines">
    <xsl:value-of select="guideline/modifiers/base"/>
    <xsl:choose>
      <xsl:when test="range = 'Personal'" />
      <xsl:when test="range = 'Adelphixis'" />
      <xsl:when test="range = 'Touch'">, +1 Touch</xsl:when>
      <xsl:when test="range = 'Eye'">, +1 Eye</xsl:when>
      <xsl:when test="range = 'Voice'">, +2 Voice</xsl:when>
      <xsl:when test="range = 'Road'">, +2 Road</xsl:when>
      <xsl:when test="range = 'Sight'">, +3 Sight</xsl:when>
      <xsl:when test="range = 'Arcane Connection'">, +4 Arcane Connection</xsl:when>
      <xsl:when test="range = 'Symbol'">, +4 Symbol</xsl:when>
      <xsl:when test="range = 'Ground'">, +4 Ground</xsl:when>
      <xsl:otherwise>RANGE ERROR</xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="duration = 'Momentary'" />
      <xsl:when test="duration = 'Special'" />
      <xsl:when test="duration = 'Dream'">, +1 Dream</xsl:when>
      <xsl:when test="duration = 'Concentration'">, +1 Concentration</xsl:when>
      <xsl:when test="duration = 'Performance'">, +1 Performance</xsl:when>
      <xsl:when test="duration = 'Diameter'">, +1 Diameter</xsl:when>
      <xsl:when test="duration = 'Sun'">, +2 Sun</xsl:when>
      <xsl:when test="duration = 'Ring'">, +2 Ring</xsl:when>
      <xsl:when test="duration = 'Fire'">, +3 Fire</xsl:when>
      <xsl:when test="duration = 'Moon'">, +3 Moon</xsl:when>
      <xsl:when test="duration = 'Month'">, +3 Month</xsl:when>
      <xsl:when test="duration = 'Helstar'">, +3 Helstar</xsl:when>
      <xsl:when test="duration = 'Bargain'">, +3 Bargain</xsl:when>
      <xsl:when test="duration = 'Until'">, +4 Until</xsl:when>
      <xsl:when test="duration = 'Year'">, +4 Year</xsl:when>
      <xsl:when test="duration = 'Year +1'">, +4 Year + 1</xsl:when>
      <xsl:when test="duration = 'Symbol'">, +4 Symbol</xsl:when>
      <xsl:otherwise>DURATION ERROR</xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="target = 'Individual'" />
      <xsl:when test="target = 'Unborn Child'" />
      <xsl:when test="target = 'Taste'" />
      <xsl:when test="target = 'Circle'" />
      <xsl:when test="target = 'Flavour'" />
      <xsl:when test="target = 'Dream'" />
      <xsl:when test="target = 'Part'">, +1 Part</xsl:when>
      <xsl:when test="target = 'Texture'">, +1 Texture</xsl:when>
      <xsl:when test="target = 'Touch'">, +1 Touch</xsl:when>
      <xsl:when test="target = 'Group'">, +2 Group</xsl:when>
      <xsl:when test="target = 'Pair'">, +2 Pair</xsl:when>
      <xsl:when test="target = 'Smell'">, +2 Smell</xsl:when>
      <xsl:when test="target = 'Scent'">, +2 Scent</xsl:when>
      <xsl:when test="target = 'Room'">, +2 Room</xsl:when>
      <xsl:when test="target = 'Sight'">, +3 Sight</xsl:when>
      <xsl:when test="target = 'Hearing'">, +3 Hearing</xsl:when>
      <xsl:when test="target = 'Sound'">, +3 Sound</xsl:when>
      <xsl:when test="target = 'Structure'">, +3 Structure</xsl:when>
      <xsl:when test="target = 'Bloodline'">, +3 Bloodline</xsl:when>
      <xsl:when test="target = 'Spectacle'">, +4 Spectacle</xsl:when>
      <xsl:when test="target = 'Boundary'">, +4 Boundary</xsl:when>
      <xsl:when test="target = 'Community'">, +4 Community</xsl:when>
      <xsl:when test="target = 'Symbol'">, +4 Symbol</xsl:when>
      <xsl:when test="target = 'Vision'">, +4 Vision</xsl:when>
      <xsl:otherwise>TARGET ERROR</xsl:otherwise>
    </xsl:choose>
    <xsl:for-each select="guideline/modifiers/modifier">, <xsl:value-of select="." /></xsl:for-each>
  </xsl:template>

  <xsl:template match="range">
    <xsl:choose>
      <xsl:when test=". = 'Personal'">Personal</xsl:when>
      <xsl:when test=". = 'Touch'">Touch</xsl:when>
      <xsl:when test=". = 'Voice'">Voice</xsl:when>
      <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="duration">
    <xsl:choose>
      <xsl:when test=". = 'Momentary'">Momentary</xsl:when>
      <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="source">
  <fo:inline font-size="6pt" color="{$handcolour}"><xsl:text> </xsl:text><xsl:value-of select="@source"/><xsl:text> </xsl:text><xsl:value-of select="@page"/></fo:inline>
  </xsl:template>

</xsl:stylesheet>