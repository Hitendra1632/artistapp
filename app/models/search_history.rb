class SearchHistory
  include Mongoid::Document
  field :history, type: Array , :default => []
  field :email,type:String
end
