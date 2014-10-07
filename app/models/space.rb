class Space < ActiveRecord::Base
  belongs_to :user

  has_many :user_spaces, dependent: :destroy
  has_many :users, through: :user_spaces

  has_many :created_members, class: Member, dependent: :destroy

  has_many :space_members, dependent: :destroy
  has_many :members, through: :space_members

  has_many :locations

  has_many :invites

  accepts_nested_attributes_for :locations

  # Space is paid for through the connected payment_method
  # but the subscription is local (to support multiple spaces on one payment method).
  belongs_to :payment_method # Plus plan and stripe_subscription_id

  scope :missing_payment_method, -> { where(payment_method_id: nil) }

  before_destroy :cancel_subscription

  validates :name, presence: true
  #validates :plan, presence: true

  def cancel_subscription
    if payment_method
      payment_method.cancel_subscription(self)
    end
  end

  def self.plans
    ["Basic-M", "Basic-Y"]
  end

  def plan_description
    @plan_descriptions ||= {
      "Basic-M" => "Basic Monthly",
      "Basic-Y" => "Basic Annually"
    }

    if self.plan
      return @plan_descriptions[self.plan]
    else
      return "No plan selected"
    end
  end

end
