# RSpec.describe Spree::SendcloudSubscriber do
#   describe 'on product_create' do
#     it 'sends the order to the Sendcloud Parcel API' do
#       order = build(:order_ready_to_ship)

#       perform_subscribers(only: described_class) do
#         Spree::Event.fire 'product_create', product: order.shipments.first
#       end

#       # verify the order has been sent to the API
#     end
#   end
# end