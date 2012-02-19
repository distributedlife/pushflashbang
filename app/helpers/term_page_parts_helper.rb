module TermPagePartsHelper
  def ok_first_review_button
    link_to t('actions.ok'), '#', :class => 'btn btn-large btn-success', :method => :post, :id => "do_results"
  end
end