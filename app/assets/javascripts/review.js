function is_review_type_enabled(review_type)
{
  return ($j("#review_result_" + review_type).length > 0) ;
};

function review_type_result(review_type)
{
  return $j("#review_result_" + review_type).val() == "1" ;
};

function review_type_query_string(review_type)
{
  if (is_review_type_enabled(review_type))
  {
    return "&" + review_type + "=" + review_type_result(review_type) ;
  }

  return "" ;
};


