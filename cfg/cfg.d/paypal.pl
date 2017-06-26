$c->{paypal}->{currency} = "EUR";

$c->{paypal}->{price} = sub {
	my( $user, $document ) = @_;
	my $price = 0; # some derived price

    $price = $document->get_value( "price" );
    

# currency, price (set shipping and tax in paypal)
	return ( $user->repository->config( qw( paypal currency ) ), sprintf( "%.02f", $price )  );
};

# This ID can either be your Secure Merchant ID, which can be found by logging 
# into your PayPal account and visiting your profile, or your email address.
$c->{paypal}->{merchantid} = 'donate.paypal-facilitator@unesco.org';
$c->{paypal}->{ipn} = $c->{"perl_url"} . '/paypal/callback/';

$c->{plugins}{'Screen::PaypalCart'}{params}{disable} = 0;
$c->{plugins}{'Screen::PaypalOrders'}{params}{disable} = 0;
$c->{plugins}{'Export::PaypalZip'}{params}{disable} = 0;
