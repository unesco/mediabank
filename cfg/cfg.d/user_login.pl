# Implement LDAP login

$c->{noise} = 4;
$c->{check_user_password} = sub {
    my( $session, $username, $password ) = @_;
    # Kerberos authentication for "user", "editor" and "admin" types (roles)

    use Net::LDAP; # IO::Socket::SSL also required
    use Authen::Krb5::Simple;
    use Authen::SASL;

    # LDAP tunables
    my $ldap_host = "ldap.yourserver.org";
    my $base      = "OU=...,DC=,DC=,DC=";
    my $proxy_user ="readonly_user";
    my $dn        = "CN=$proxy_user,$base";


    # Kerberos tunables
    my $krb_host = "hereweusekerberosfordemopurpose";
    my $krb = Authen::Krb5::Simple->new(realm => $krb_host);

    unless ( $krb ) {
        print STDERR "Kerberos error: $@\n";
        return 0;
    }

    my $ldap      = Net::LDAP->new ( $ldap_host );
    unless( $ldap ) {
        print STDERR "LDAP error: $@\n";
        return 0;
    }

    my $sasl = Authen::SASL->new(
        mechanism => 'GSSAPI',
        callback => { user => 'ad_read' }
    ) or die "$@";

    my $mesg = $ldap->bind(sasl => $sasl);# dn => $dn, password=>$ldappass );
    if( $mesg->code() ) {
        print STDERR "LDAP Bind error: " . $mesg->error() . "\n";
        return 0;
    }

    # Distinguished name (and attribues needed later on) for this user
    my $result = $ldap->search (
        base    => "$base",
        filter  => "(&(sAMAccountName=$username))",
        attrs   =>  ['1.1', 'uid', 'sn', 'givenname', 'mail', 'department'],
        sizelimit=>1
    );

    my $entr = $result->pop_entry;
    unless( defined $entr ){
        # Allow local EPrints authentication for admins (accounts not found in LDAP)
        my $user = EPrints::DataObj::User::user_with_username( $session, $username );
        return 0 unless $user;

        my $user_type = $user->get_type;
        if( $user_type eq "admin" || $user_type eq "user" || $user_type eq "editor" || $user_type eq "minuser" ){
            # internal authentication for "admin" type
            return $session->get_database->valid_login( $username, $password );
        }
        return 0;
    }

    # Check password
    if( !$krb->authenticate( $username, $password ) ){
        print STDERR "$username authentication failed: ", $krb->errstr(), "\n";
        return 0;
    }

    # Does account already exist?
    my $user = EPrints::DataObj::User::user_with_username( $session, $username );
    if( !defined $user ) {
        # New account
        $user = EPrints::DataObj::User::create( $session, "user" );
        $user->set_value( "username", $username );
    }

    # Set metadata
    my $name = {};
    $name->{family} = $entr->get_value( "sn" );
    $name->{given} = $entr->get_value( "givenName" );
    $user->set_value( "name", $name );
    $user->set_value( "username", $username );
    $user->set_value( "email", $entr->get_value( "mail" ) );
    $user->set_value( "dept", $entr->get_value( "department" ) );
    $user->commit();

    $ldap->unbind if $ldap;

    return 1;
}
