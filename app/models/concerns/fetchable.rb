module Fetchable extend ActiveSupport::Concern

  included do
    scope :sort, -> (params) { order(params[:sort]) if params[:sort].present? }
    scope :pagination, -> (params)  { page(params[:page] ||= 1).per(params[:per_page] ||= 10) }
    scope :fetch, -> (params = {}) { sort(params).pagination(params) }
  end

end