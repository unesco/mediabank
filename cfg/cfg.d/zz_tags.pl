# Instructions
#
# Inspired by http://bazaar.eprints.org/157/
#
# In order to make it works, you have to create one or two fields for hosting your tags.
# I personally found the two fields solution to be easier for editors, especially if you have a
# multilingual repository.
#
####################################
# Two fields solution:
####################################
# ./cfg/cfg.d/eprints_fields.pl
#{
#    name => "tags",
#    type => "text",
#    multiple => 1,
#    export_as_xml => 0,
#},
#{
#    name => "keywords",
#	type => "subject",
#	multiple => 1,
#	top => "keywords",
#	browse_link => "keywords",
#    export_as_xml => 1,
#},
#
# ./cfg/cfg.d/eprints_fields_automatic.pl
#   ...
#    my @keywords;
#    my @tags;
#    if( $eprint->dataset->has_field( "tags" ) && $eprint->is_set( "tags" ) ) {
#        @tags = @{$eprint->get_value( "tags" )};
#    }
#
#    for ( my $i=0; $i<@tags; ++$i) {
#        push @keywords,@tags->[$i];
#    }
#
#    @keywords = sort @keywords;
#    $eprint->set_value( "keywords", \@keywords );
#    ...
#
# When you've created your fields don't forget to update the database and reload the repository.
#
# Make sure your AutoSubjects.pm is in the right place:
# ./cfg/plugins/EPrints/Plugin/Event/AutoSubjects.pm
#
# For each configured field you will need to schedule a subjects-tree update:
#
#  ./tools/schedule --cron "15 12 * * *" [REPOID] Event::AutoSubjects update [DATASETID] [FIELDID]
#
# Where DATASETID and FIELDID is the field containing the raw (user-entered) tags.
# This special configuration set a cronjob that sync your tags with your subject tree.
# It will not work if the indexer is not running.
#
# To do your testing simply:
#
#  ./tools/schedule mediabank Event::AutoSubjects update eprint tags
#  ./bin/indexer debug --once --verbose  --retry

# enable the AutoSubjects plugin
$c->{plugins}{"Event::AutoSubjects"}{params}{disable} = 0;
