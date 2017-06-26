
$c->{set_document_defaults} = sub 
{
	my( $data, $repository, $eprint ) = @_;

	$data->{language} = $repository->get_langid();
  $data->{security} = "public";
  $data->{license} = "cc_by_sa_3_igo";
  $data->{content} = "original";
  $data->{price} = 0;
  $data->{language} = "none";
};
