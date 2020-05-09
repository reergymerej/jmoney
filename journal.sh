#!/usr/bin/env bash
J=$1_Journal_Current.markdown
A=$1_Journal_Archive.markdown
M=$(cat modelines_for_journals)
case "$1" in
	"Professional")
		P=$(sed -n "/## Things and Stuff/,/## Completed/p" $J);;
	"Nethack")
		P=$(cat Nethack_Journal_Template.markdown);;
	*) echo "Youze a big dummy."; exit ;;
esac
if [ ! -f "$A" ]; then
	echo "Creating archive at $A"
	echo -e "$M\n\n" > $A
fi
echo "Archiving $J to $A"
head $J --lines=-1 >> $A
echo "Creating new page in $J"
echo -e "# $(date)\n\n$P\n\n\n$M" > $J
echo "Done"

