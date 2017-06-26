push @{$c->{fields}->{eprint}},

# The eprint_fields

#
# Compounds fields
#


# Creators
# Creator is a multiple field with the creator name and ID.
# The id is used to retrieve the creator extra information.

{
    name => 'creators',
    type => 'compound',
    multiple => 1,
    fields => [
        {
            sub_name => 'name',
            type => 'name',
            browse_link => 'creators',
            hide_honourific => 1,
            hide_lineage => 1,
            family_first => 1,
            allow_null => 1,
        },
        {
            sub_name => 'dept',
            type => 'text',
            input_cols => 20,
            allow_null => 1,
        }
    ],
    input_boxes => 1,
},

#
# Location Shown in the Image
#
{
    name => 'where_shown',
    type => 'compound',
    render_value => 'render_compound_country',
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
            allow_null => 1,
            export_as_xml => 1,
            input_boxes => 3,
            input_cols => 10,
            input_rows => 10,
            input_style => 'short',
            multiple => 0,
            sub_name => 'country',
            required => 1,
            set_name => 'countries',
            type => 'namedset',
            search_input_style => 'select',
            volatile => 0,
            browse_link => 'countries'
        }
    ],
    input_boxes => 1,
    input_ordered => 0,
    browse_link => 'countries'
},

#
# Related URLs
#
{
    name => 'related_url',
    type => 'compound',
    multiple => 1,
    render_value => 'render_compound_url',
    fields => [
        {
            sub_name => 'url',
            type => 'url',
            input_cols => 40,
        },
        {
            sub_name => 'type',
            type => 'text',
            input_cols => 20,
            allow_null => 1,
        }
	],
	input_boxes => 1,
	input_ordered => 0,
},

#
# Multilingual fields
#
;
