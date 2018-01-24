#!/bin/bash

# locate saxon jar file
sax_jar=lib/SaxonHE9-8-0-7J/saxon9he.jar

# locate FOP base directory
fop_lib=lib/fop-2.1

# additional options for FOP processing (sent to the java process)
#   -d64: optimization for 64 bit processor
#   -Xmx3000m: sets the maximum available memory allocation pool to 3000 MB
# Note: It's safe to leave this variable blank
fop_opts="-d64 -Xmx3000m"

# these variables shouldn't need to be changed, they are relative to fop_lib
fop_bin=${fop_lib}/fop
fop_conf=${fop_lib}/conf/fop.xconf

fo_obj=output/pdf.fo
pdf_obj=output/pdf.pdf

tei_xsl=lib/tei2pdf/TEIcorpus_producer.xsl
xslfo_xsl=lib/tei2pdf/xsl-fo-producer.xsl
init_xml=lib/tei2pdf/empty.xml
final_xml=output/Book_Corpus.xml

# further options that may be useful

# cleanup transitional files when finished
cleanup=true
