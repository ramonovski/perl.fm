#!/usr/bin/env perl
use strict;
use XML::Writer;
use IO;

open (my $scrobblelog, "<", "scrobbler.log") || die "no se armo $!";
my @lines = <$scrobblelog>;

my $count = @lines;
my $output = new IO::File(">out.xml");
my $writer = new XML::Writer(OUTPUT => $output, newline => 1);

$writer->xmlDecl('UTF-8');
$writer->startTag("lfm",
				  "status" => "status");
$writer->characters("\n");
$writer->characters("\t");
$writer->startTag("scrobbles",
				  "accepted" => "$count",
				  "ignored" => "0");
$writer->characters("\n");

for my $line (@lines)
{
	chomp;
	my @scrob = split('\t', $line);
	unless ($line =~ m/^\#/)
	{
		print "$scrob[0]\n";

		$writer->characters("\t\t");
		$writer->startTag("scrobble");
		$writer->characters("\n");
		$writer->characters("\t\t");
		$writer->startTag("track",
						  "corrected" => "0");
		$writer->characters("$scrob[2]");
		$writer->endTag("track");
		$writer->characters("\n");
		$writer->characters("\t\t");
		$writer->startTag("artist",
						  "corrected" => "0");
		$writer->characters("$scrob[0]");
		$writer->endTag("artist");
		$writer->characters("\n");
		$writer->characters("\t\t");
		$writer->startTag("album",
						  "corrected" => "0");
		$writer->characters("$scrob[1]");
		$writer->endTag("album");
		$writer->characters("\n");
		$writer->characters("\t\t");
		$writer->startTag("timestamp");
		$writer->characters("$scrob[6]");
		$writer->endTag("timestamp");
		$writer->characters("\n");
		$writer->characters("\t\t");
		$writer->endTag("scrobble");
		$writer->characters("\n");
	}
}

$writer->characters("\t");
$writer->endTag("scrobbles");
$writer->characters("\n");
$writer->endTag("lfm");
$writer->end();
$output->close();

#ok
=pod
<?xml version='1.0' encoding='utf-8'?>
<lfm status="ok">
	<scrobbles accepted="1" ignored="0">
		<scrobble>
		<track corrected="0">Test Track</track>
		<artist corrected="0">Test Artist</artist>
		<album corrected="0"></album>
		<albumArtist corrected="0"></albumArtist>
		<timestamp>1287140447</timestamp>
		<ignoredMessage code="0"></ignoredMessage>
		</scrobble>
	</scrobbles>
</lfm>
=cut
