class BlockedUser < ApplicationRecord
    belongs_to :blocked_by, class_name: 'User', foreign_key: "blocked_by_id" 
    belongs_to :blocked, class_name: 'User', foreign_key: "blocked_id" 
end
