#!/usr/bin/env bash
# journal_backup.sh - Back up my journals to an archive and create a new clean entry
# use: sh journal_backup.sh [single word journal name]
# example: sh journal_backup.sh Professional
# This script preserves information form the current page or looks to a template file to create a
# new page. It then appends the entire current page to the archive and creates a new page using
# the preserved info or template. Currently only uses markdown format because markdown is cool.

# Define the file names for the current journal and archive
JOURNAL=$1_Journal_Current.markdown
ARCHIVE=$1_Journal_Archive.markdown

# Now with case instead of if statement
case "$1" in
	"Professional") 
		# If this is my professional journal, then we need to preserve everything still in the 
		# '## Things and Stuff' block, which exists between that 2nd level headline and the
		# '## Completed' headline. We can add in cases here for additional journals as time goes on.
		# For example, the Nethack journal has it's own structure, and the Personal journal basically
		# has no structure so we can do WTF we want there.
		PRESERVE=$(sed -n "/## Things and Stuff/,/## Completed/p" $JOURNAL);;

	"Nethack")
		# If this is my Nethack journal then we just write the whole thing to archive and then preserve
		# the basic goals and the headlines, which we store in a template file to avoid having to
		# write it all in here.
		PRESERVE=$(cat Nethack_Journal_Template.markdown);;

	# I'm just reserving this space for additional cases to be handled. I haven't yet defined
	# my personal journal.. which I think says a lot about me...

	# And a whoopsie message in case I fuck everything up because why not?
	*) echo "Youze a big dummy."; exit ;;
esac

# These are my favorite modelines. Include them in the files!
MODELINES="# vim: lbr ai showbreak=>\ "

# If the archive already exists, use it. If not, create a new one with modelines at the bottom.
if test -f "$ARCHIVE"; then
	echo "Archiving $JOURNAL to $ARCHIVE"
else
	echo "Creating $ARCHIVE for journal"
	echo -e "$MODELINES\n\n" > $ARCHIVE
fi

# Append everything except the modelines from the current journal entry.
head $JOURNAL --lines=-1 >> $ARCHIVE

# Create the new page starting with the preserve text
echo -e "# $(date)\n\n$PRESERVE\n\n\n$MODELINES" > $JOURNAL

# I removed the automatic starting of the VIM process because it was superfluous. However, I
# would like to see if there's a VIM instance running and open the new page in a new buffer
# automatically.

