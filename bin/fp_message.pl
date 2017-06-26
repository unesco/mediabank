#!/usr/bin/perl -w

use FindBin;
use lib "$FindBin::Bin/../../../perl_lib";
use lib '/opt/eprints3/perl_lib';

use EPrints;
use strict;

my $repoid = $ARGV[0];
my $repo = new EPrints::Session( 1 , $repoid );
EPrints::abort( "Failed to load repository: $repoid\n" ) unless defined $repo;

my $dbh = $repo->database->{dbh};

# SQL to grab dynamic parts of message
# total number of live eprints
my $num_eprints = $dbh->selectrow_arrayref( 'SELECT COUNT(*) FROM eprint WHERE eprint_status="archive"' )->[0];
# list of selected countries
my %list_countries;
my $sql = 'SELECT where_shown_country, COUNT(where_shown_country) FROM eprint WHERE eprint_status="archive" AND where_shown_country IS NOT NULL GROUP BY where_shown_country ORDER BY RAND() LIMIT 10;';
my $sth = $dbh->prepare($sql);
$sth->execute();
while (my ($key, $value) = $sth->fetchrow_array) {
    $list_countries{$key} = $value;
}
# number of countries
my $num_countries = $dbh->selectrow_arrayref( 'SELECT COUNT(DISTINCT(where_shown_country)) FROM eprint WHERE eprint_status="archive" AND where_shown_country IS NOT NULL;' )->[0];
# list of selected collections
my %list_collections;
# list of selected events
my %list_events;
$sql = 'SELECT event, COUNT(event) FROM eprint WHERE eprint_status="archive" AND event IS NOT NULL GROUP BY event ORDER BY RAND() LIMIT 10;';
$sth = $dbh->prepare($sql);
$sth->execute();
while (my ($key, $value) = $sth->fetchrow_array) {
    $list_events{$key} = $value;
}
# list of selected vip
my %list_vips;
my %list_vips_link;
$sql = 'SELECT person_shown_given, person_shown_family, person_shown_honourific, COUNT(person_shown_family) FROM eprint_person_shown WHERE person_shown_family IS NOT NULL GROUP BY person_shown_family, person_shown_given, person_shown_honourific ORDER BY RAND() LIMIT 10;';
$sth = $dbh->prepare($sql);
$sth->execute();
while (my ($given, $family, $title, $value) = $sth->fetchrow_array) {
    my $key = join(" ", $given, $family, $title);
    $list_vips{$key} = $value;
    $list_vips_link{$key} = join("=3A", $family, $given, "", $title);
}
# list of selected subjects
my %list_subjects;
$sql = 'SELECT subjects, COUNT(subjects) FROM eprint_subjects WHERE subjects IS NOT NULL GROUP BY subjects ORDER BY RAND() LIMIT 10;';
$sth = $dbh->prepare($sql);
$sth->execute();
while (my ($key, $value) = $sth->fetchrow_array) {
    $list_subjects{$key} = $value;
}

# oldest year
my $min_year = $dbh->selectrow_arrayref( 'SELECT MIN(date_year) FROM eprint WHERE eprint_status="archive"' )->[0];
if (int($min_year) < 1946) {
  $min_year = 1946;
}
# most recent year
my $max_year = $dbh->selectrow_arrayref( 'SELECT MAX(date_year) FROM eprint WHERE eprint_status="archive"' )->[0];

# make numbers more readable
$num_eprints = &commify( $num_eprints );
$num_countries = &commify( $num_countries );

# generate a message in each supported language
foreach my $langid ( @{$repo->config( "languages" )} ) {
    my $lang = $repo->get_language( $langid );
    next unless defined $lang;
    
    my $target = sprintf( "%s/%s/fp_message.html", $repo->config( "htdocs_path" ), $langid );
    print "Writing $target..\n";
    open( MSG, ">:utf8", $target ) or EPrints::abort( "Failed to write $target: $!" );
    my $msg = $lang->phrase( "fp_message", {
        num_eprints => $repo->xml->create_text_node( $num_eprints ),
        num_countries => $repo->xml->create_text_node( $num_countries ),
        min_year => $repo->xml->create_text_node( $min_year ),
        max_year => $repo->xml->create_text_node( $max_year ),
    });
    print MSG EPrints::XML::to_string( $msg );
    close MSG;
    
    $target = sprintf( "%s/%s/fp_browse_countries.html", $repo->config( "htdocs_path" ), $langid );
    print "Writing $target..\n";
    open( MSG, ">:utf8", $target ) or EPrints::abort( "Failed to write $target: $!" );
    $msg = "";
    for my $country (keys %list_countries) {
        $msg = $lang->phrase( "frontpage:replace:fp_browse", {
            alink => $repo->xml->create_element( "a", href => "view/countries/" . $country . ".html" ),
            name => $repo->html_phrase( "countries_typename_" . $country ),
            count => $repo->xml->create_text_node( $list_countries{$country} ),
        });
        print MSG EPrints::XML::to_string( $msg );        
    }
    close MSG;
    
    $target = sprintf( "%s/%s/fp_browse_collections.html", $repo->config( "htdocs_path" ), $langid );
    print "Writing $target..\n";
    open( MSG, ">:utf8", $target ) or EPrints::abort( "Failed to write $target: $!" );
    $msg = "";
    for my $keyword (keys %list_collections) {
        $msg = $lang->phrase( "frontpage:replace:fp_browse", {
            alink => $repo->xml->create_element( "a", href => "view/collections/" . $keyword . ".html" ),
            name => $repo->xml->create_text_node( $keyword ),
            count => $repo->xml->create_text_node( $list_collections{$keyword} ),
        });
        print MSG EPrints::XML::to_string( $msg );        
    }
    close MSG;
    
    $target = sprintf( "%s/%s/fp_browse_events.html", $repo->config( "htdocs_path" ), $langid );
    print "Writing $target..\n";
    open( MSG, ">:utf8", $target ) or EPrints::abort( "Failed to write $target: $!" );
    $msg = "";
    for my $event (keys %list_events) {
        $msg = $lang->phrase( "frontpage:replace:fp_browse", {
            alink => $repo->xml->create_element( "a", href => "view/events/" . $event =~ s/ /_/rg . ".html" ),
            name => $repo->xml->create_text_node( $event ),
            count => $repo->xml->create_text_node( $list_events{$event} ),
        });
        print MSG EPrints::XML::to_string( $msg );        
    }
    close MSG;
    
    $target = sprintf( "%s/%s/fp_browse_vips.html", $repo->config( "htdocs_path" ), $langid );
    print "Writing $target..\n";
    open( MSG, ">:utf8", $target ) or EPrints::abort( "Failed to write $target: $!" );
    $msg = "";
    for my $vip (keys %list_vips) {
        $msg = $lang->phrase( "frontpage:replace:fp_browse", {
            alink => $repo->xml->create_element( "a", href => "view/vips/" . $list_vips_link{$vip} =~ s/ /_/rg . ".html" ),
            name => $repo->xml->create_text_node( $vip ),
            count => $repo->xml->create_text_node( $list_vips{$vip} ),
        });
        print MSG EPrints::XML::to_string( $msg );        
    }
    close MSG;
    
    $target = sprintf( "%s/%s/fp_browse_subjects.html", $repo->config( "htdocs_path" ), $langid );
    print "Writing $target..\n";
    open( MSG, ">:utf8", $target ) or EPrints::abort( "Failed to write $target: $!" );
    $msg = "";
    my $sql2 = qq/SELECT a.name_name FROM subject_name_name a LEFT JOIN subject_name_lang b ON a.subjectid = b.subjectid WHERE b.name_lang = ? AND a.subjectid = ?/;
    my $sth2 = $dbh->prepare($sql2);
    for my $subject (keys %list_subjects) {
        $sth2->execute(($langid, $subject));
        next if !defined(my $tname = $sth2->fetchall_arrayref([], 1)->[0]->[0]);
        $msg = $lang->phrase( "frontpage:replace:fp_browse", {
            alink => $repo->xml->create_element( "a", href => "view/subjects/" . $subject . ".html" ),
            name => $repo->xml->create_text_node( $tname ),
            count => $repo->xml->create_text_node( $list_subjects{$subject} ),
        });
        print MSG EPrints::XML::to_string( $msg );        
    }
    close MSG;
    
    
}

$repo->terminate;

# from http://perldoc.perl.org/perlfaq5.html#How-can-I-output-my-numbers-with-commas-added%3f
sub commify
{
	local $_  = shift;
	1 while s/^([-+]?\d+)(\d{3})/$1,$2/;
	return $_;
}
