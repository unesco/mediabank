package EPrints::Plugin::Event::AutoSubjects;

@ISA = qw( EPrints::Plugin::Event );

use strict;

sub update
{
	my( $self, $datasetid, $fieldid ) = @_;

	my $repo = $self->{repository};

	my $dataset = $repo->dataset( $datasetid );
	return if !defined $dataset;

	my $field = $dataset->field( $fieldid );

	my $root = $dataset->base_id . "_" . $field->name;

	my %tree;
	my %nodes;
	my %parent;
	my %depth;
	my %names;

	$dataset->search->map(sub {
		(undef, undef, my $dataobj ) = @_;

		my @values = @{$field->get_value( $dataobj )||[]};
		foreach my $value (@values)
		{
			my @path = split /\s*;\s*/, $value;
			foreach my $id (@path)
			{
				my $name = $id;
				$id = lc($id);
				$id =~ s/\s+/_/g;
				next if exists $nodes{$id};
				$names{$id} = $name;
				$parent{$id} = \%tree;
				$tree{$id} = $nodes{$id} = {};
				$depth{$id} = 1;
			}
			foreach my $i (1..$#path)
			{
				my( $parentid, $id ) = @path[$i-1, $i];

				# child is already lower than parent, so ignore it
				next if $depth{$id} > $depth{$parentid};

				# this would create a loop, so ignore it
				next if contains( $nodes{$id}, $parentid );

				# move this node from its current parent to the new parent
				my $node = delete $parent{$id}{$id};
				$parent{$id} = $nodes{$parentid};
				$nodes{$parentid}{$id} = $node;

				# update the depth of this node and all its children
				update_depth(\%depth, $nodes{$parentid}, $depth{$parentid} + 1);
			}
		}
	});

	my $subjects = $repo->dataset( "subject" );

	$subjects->search(
		filters => [
			{ meta_fields => [qw( ancestors )], value => $root },
		],
	)->map(sub {
		(undef, undef, my $subject) = @_;

		# DataObj::Subject prevents removal of subjects with children
		$subject->EPrints::DataObj::remove;
	});

	$subjects->create_dataobj({
		subjectid => $root,
		parents => ["ROOT"],
		name => [{
			name => $self->{session}->xhtml->to_text_dump( $field->render_name ),
			lang => "en",
		}],
	});

	my %inodes = reverse %nodes;
	foreach my $id (sort keys %nodes)
	{
		$subjects->create_dataobj({
			subjectid => $id,
			parents => [$inodes{$parent{$id}} || $root],
			name => [{
				name => $names{$id},
				lang => "en",
			}],
		});
	}

	return undef;
}

sub contains
{
	my( $tree, $id ) = @_;

	foreach my $cid (keys %$tree)
	{
		return 1 if $cid eq $id;
		return 1 if contains( $tree->{$cid}, $id  );
	}

	return 0;
}

sub update_depth
{
	my( $depth, $node, $n ) = @_;

	while(my( $k, $child) = each %$node)
	{
		$depth->{$k} = $n;
		update_depth( $depth, $child, $n + 1 );
	}
}

1;
