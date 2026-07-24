{{number_headers(6)}}

# Wiki

## Header Numbering

This is an example of header numbering.
Level 1 headers are reserved for titles and will not be numbered.

### Format

It should be in the format:

\## 1 Header  
\### 1.1 Sub Header

### Links

Links will be upgraded to match the numbered headers:

Link to Section 2.2.3 will be upgraded with numbering: [Section 2.2.3](#Section-223)

A special link, with only a '#' as caption, will be formatted as a numbering only reference:  
[\#]\(\#Section-223) becomes: [#](#Section-223)

## Section 2

### Section 2.1

#### Section 2.1.1

##### Section 2.1.1.1

###### Section 2.1.1.1.1

Since Redmine only supports 6 levels of headings, and level 1 is reserved,  
the following will not be formatted:

####### Section 2.1.1.1.1.1

###### Section 2.1.1.1.2

### Section 2.2

Skip Section 2.2.1 intentionally, it will be counted implicitly.

###### Section 2.2.1.1.1

###### Section 2.2.1.1.2

#### Section 2.2.2

#### Section 2.2.3

##### Section 2.2.3.1

#### Section 2.2.4

## And finally: Section 3

# End Of Wiki