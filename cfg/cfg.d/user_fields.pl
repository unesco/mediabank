
push @{$c->{fields}->{user}},

#
# The address field is a multi-line field.
#
{
    name => 'address',
    type => 'compound',
    multiple => 0,
    fields => [
        {
            sub_name => 'sublocation',
            type => 'text',
            input_cols => 20,
            allow_null => 1,
        },
        {
            sub_name => 'city',
            type => 'text',
            input_cols => 20,
            allow_null => 1,
        },
        {
            sub_name => 'state',
            type => 'text',
            input_cols => 20,
            allow_null => 1,
        },
        {
            'allow_null' => '1',
            'export_as_xml' => '0',
            'input_boxes' => '3',
            'input_cols' => '60',
            'input_ordered' => '0',
            'input_rows' => '10',
            'input_style' => 'short',
            'maxlength' => '255',
            'multiple' => '0',
            'sub_name' => 'country',
            'provenance' => 'user',
            'required' => '1',
            'set_name' => 'countries',
            'sql_index' => '0',
            'type' => 'namedset',
            'volatile' => '0',
            'browse_link' => 'countries'
        }
    ],
    input_boxes => 1,
    input_ordered => 0,
},
;
