describe Spree::VendWebhooksController do
   
   describe "POST receive" do
      context "when the action exists" do
         let(:handle_customer_update) { file_fixture("handle_customer_update_fixture.json").read }

         it "delegates to the right handler method" do
            # post "/vend_webhooks/receive", :params => { "type": "inventory_update" }
         end

         it "it returns status code 200" do
            post :receive
            expect(response.status).to be(200)
         end
      end
   
      context "when the action does not exist" do
         it "raises a NoMethodError" do
            expect { raise NoMethodError }.to raise_error(NoMethodError)
         end
      end
   end

   describe "#handle_sale_update" do
   
   end

   describe "#handle_customer_update" do
      
      context "when a customer is found by vend_id" do
         it "updates the customer" do
         end
      end

      context "when a customer is found by email" do
         it "updates the customer" do
         end
      end

      context "when no customer is found by vend_id or email" do
         it "creates a new customer" do
         end
      end
   end
end