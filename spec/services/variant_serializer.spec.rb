describe SendcloudServices::ShipmentSerializer do
   describe "#call" do
      let(:variant) { build(:order_ready_to_ship, line_items_count: 2) }

      context "when given a valid variant" do
         subject(:parcel_payload) { described_class.call(order.shipments.first) }

         it 'returns a valid json payload' do
            expect(JSON.parse(parcel_payload)['parcel']['order_number']).to eq(order.number)
         end
      end
     
   end
end