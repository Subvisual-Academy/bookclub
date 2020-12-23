module DomHelpers
  def dom_id(record)
    ActionView::RecordIdentifier.dom_id(record)
  end
end
