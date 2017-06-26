#new metafield type
use EPrints::MetaField::Virtualwithvalue;

#please use these field definitions as examples of what can be done

#define local fields
my $new_fields = [
{
	name => 'ml_title',
	type => 'multilang',
	multiple => 1,
	fields => [ { sub_name => "text", type => "text", make_single_value_orderkey => 'EPrints::Extras::english_title_orderkey' } ],
	input_add_boxes => 1,
},
{
	name => 'ml_abstract',
	type => 'multilang',
	multiple => 1,
	fields => [ { sub_name => "text", type => "longtext", input_rows => 10 } ],
	input_add_boxes => 1,
},
{
	name => 'ml_headline',
	type => 'multilang',
	multiple => 1,
	fields => [ { sub_name => "text", type => "text" } ],
	input_add_boxes => 1,
},
];

foreach my $field_def(@{$new_fields})
{
	$c->add_dataset_field('eprint', $field_def);

}

my $virtualised_fields = [
{
	name => 'title',
	type => 'virtualwithvalue',
	virtual => 1,
  export_as_xml => 0,
	get_value => sub
	{
		my ($eprint) = @_;
		return $eprint->repository->call('ml_field_get_single_ml_value', $eprint, 'ml_title');
	},
	set_value => sub
	{
		my ($eprint, $value) = @_;
		return $eprint->repository->call('ml_field_set_single_ml_value', $eprint, 'ml_title', $value);
	}
},
{
	name => 'abstract',
	type => 'virtualwithvalue',
	virtual => 1,
  export_as_xml => 0,
	get_value => sub
	{
		my ($eprint) = @_;
		return $eprint->repository->call('ml_field_get_single_ml_value', $eprint, 'ml_abstract');
	},
	set_value => sub
	{
		my ($eprint, $value) = @_;
		return $eprint->repository->call('ml_field_set_single_ml_value', $eprint, 'ml_abstract', $value);
	}
},
{
	name => 'headline',
	type => 'virtualwithvalue',
	virtual => 1,
  export_as_xml => 0,
	get_value => sub
	{
		my ($eprint) = @_;
		return $eprint->repository->call('ml_field_get_single_ml_value', $eprint, 'ml_headline');
	},
	set_value => sub
	{
		my ($eprint, $value) = @_;
		return $eprint->repository->call('ml_field_set_single_ml_value', $eprint, 'ml_headline', $value);
	}
},
];


#create lookup hash of local field names
my $virtualised_fieldnames = {};
my $local_fields = [];


foreach my $f (@{$virtualised_fields})
{
	$virtualised_fieldnames->{$f->{name}} = 1;
	push @{$local_fields}, $f;
}

#merge in existing field configurations
foreach my $f (@{$c->{fields}->{eprint}})
{
	if (!$virtualised_fieldnames->{$f->{name}})
	{
		push @{$local_fields}, $f;
	}
}

#overwrite original array of configured fields
$c->{fields}->{eprint} = $local_fields;


$c->{ml_field_get_single_ml_value} = sub
{
	my ($eprint, $fieldname) = @_;

	if ($eprint->is_set($fieldname))
	{

		my $vals = $eprint->get_value($fieldname);
		my $val = undef;

		my $lang = $eprint->repository->get_langid;
		if ($lang)
		{
			foreach my $v (@{$vals})
			{
				if ($v->{lang} eq $lang)
				{
					$val = $v->{text};
					last;
				}
			}
		}

		return $val if defined $val;

		#if we didn't get a val (perhaps no value for default language), try to return something

		if (
			!defined $val
			&& defined $vals
			&& defined $vals->[0]
			&& defined $vals->[0]->{text}
		)
		{
			$val = $vals->[0]->{text};
		}

		return $val;

	}
	return undef;
};

$c->{ml_field_set_single_ml_value} = sub
{
	my ($eprint, $fieldname, $value) = @_;
	my $lang = $eprint->repository->get_langid;
	$lang = $c->{defaultlanguage} unless $lang;
	$lang = 'en' unless $lang;

	#only use this on imports, NOT if the value is already set
	if ($eprint->is_set($fieldname))
	{
		return;
	}
	if ($value)
	{
		$eprint->set_value($fieldname, [{lang=>$lang, text=>$value}]);
	}
};

