$c->{set_eprint_defaults} = sub{
    my( $data, $repository ) = @_;
    $data->{type} = "image";
    $data->{credit_line} = "© UNESCO";
    # TODO  Issue #41
    # $data->{contact_email} = user_email
};
