<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:java="http://xml.apache.org/xslt/java"
  exclude-result-prefixes="java" xmlns:fo="http://www.w3.org/1999/XSL/Format">  

  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
  <xsl:variable name="uorientation" select="translate($orientation, $smallcase, $uppercase)"/>
  <xsl:variable name="upaper" select="translate($paper, $smallcase, $uppercase)"/>
  <xsl:variable name="wide">
    <xsl:choose>
      <xsl:when test="$uorientation='LANDSCAPE'">-wide</xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="cols">
    <xsl:choose>
      <xsl:when test="$uorientation='LANDSCAPE' and $upaper='TABLOID'">4</xsl:when>
      <xsl:when test="$upaper='TABLOID'">3</xsl:when>
      <xsl:when test="$uorientation='LANDSCAPE'">3</xsl:when>
      <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="tablecols">
    <xsl:choose>
      <xsl:when test="$uorientation='LANDSCAPE' and $upaper='TABLOID'">5</xsl:when>
      <xsl:when test="$upaper='TABLOID'">4</xsl:when>
      <xsl:when test="$uorientation='LANDSCAPE'">4</xsl:when>
      <xsl:otherwise>3</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
  <xsl:variable name="textcols">
    <xsl:choose>
      <xsl:when test="$uorientation='LANDSCAPE' and $upaper='TABLOID'">3</xsl:when>
      <xsl:when test="$uorientation='LANDSCAPE'">2</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="width">
    <xsl:choose>
      <xsl:when test="$uorientation='LANDSCAPE'">
        <xsl:choose>
          <xsl:when test="$upaper='A4'">11.7in</xsl:when>
          <xsl:when test="$upaper='TABLOID'">17in</xsl:when>
          <xsl:otherwise>11in</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$upaper='A4'">8.3in</xsl:when>
          <xsl:when test="$upaper='TABLOID'">11in</xsl:when>
          <xsl:otherwise>8.5in</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="height">
    <xsl:choose>
      <xsl:when test="$uorientation='LANDSCAPE'">
        <xsl:choose>
          <xsl:when test="$upaper='A4'">8.3in</xsl:when>
          <xsl:when test="$upaper='TABLOID'">11in</xsl:when>
          <xsl:otherwise>8.5in</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$upaper='A4'">11.7in</xsl:when>
          <xsl:when test="$upaper='TABLOID'">17in</xsl:when>
          <xsl:otherwise>11in</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
</xsl:stylesheet>