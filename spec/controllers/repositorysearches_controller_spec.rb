require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe EqueryReport::RepositorysearchesController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Repositorysearch. As you add validations to Repositorysearch, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RepositorysearchesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

#   describe "GET index" do
#     it "assigns all repositorysearches as @repositorysearches" do
#       repositorysearch = Repositorysearch.create! valid_attributes
#       get :index, {}, valid_session
#       expect(assigns(:repositorysearches)).to eq([repositorysearch])
#     end
#   end

  describe "GET show" do
    it "assigns the requested repositorysearch as @repositorysearch" do
      repositorysearch = Repositorysearch.create! valid_attributes
      get :show, {:id => repositorysearch.to_param}, valid_session
      expect(assigns(:repositorysearch)).to eq(repositorysearch)
    end
  end

  describe "GET new" do
    before do
      @admin_user=FactoryGirl.create(:admin_user)
      sign_in(@admin_user)
    end
    it "assigns a new repositorysearch as @repositorysearch" do
      repositorysearch = Repositorysearch.create! valid_attributes
      get :new, {}, valid_session
      expect(assigns(:repositorysearch)).to be_a_new(Repositorysearch)
    end
  end

#   describe "GET edit" do
#     it "assigns the requested repositorysearch as @repositorysearch" do
#       repositorysearch = Repositorysearch.create! valid_attributes
#       get :edit, {:id => repositorysearch.to_param}, valid_session
#       expect(assigns(:repositorysearch)).to eq(repositorysearch)
#     end
#   end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Repositorysearch" do
        expect {
          post :create, {:repositorysearch => valid_attributes}, valid_session
        }.to change(Repositorysearch, :count).by(1)
      end

      it "assigns a newly created repositorysearch as @repositorysearch" do
        post :create, {:repositorysearch => valid_attributes}, valid_session
        expect(assigns(:repositorysearch)).to be_a(Repositorysearch)
        expect(assigns(:repositorysearch)).to be_persisted
      end

      it "redirects to the created repositorysearch" do
        post :create, {:repositorysearch => valid_attributes}, valid_session
        expect(response).to redirect_to(Repositorysearch.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved repositorysearch as @repositorysearch" do
        post :create, {:repositorysearch => invalid_attributes}, valid_session
        expect(assigns(:repositorysearch)).to be_a_new(Repositorysearch)
      end

      it "re-renders the 'new' template" do
        post :create, {:repositorysearch => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested repositorysearch" do
        repositorysearch = Repositorysearch.create! valid_attributes
        put :update, {:id => repositorysearch.to_param, :repositorysearch => new_attributes}, valid_session
        repositorysearch.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested repositorysearch as @repositorysearch" do
        repositorysearch = Repositorysearch.create! valid_attributes
        put :update, {:id => repositorysearch.to_param, :repositorysearch => valid_attributes}, valid_session
        expect(assigns(:repositorysearch)).to eq(repositorysearch)
      end

      it "redirects to the repositorysearch" do
        repositorysearch = Repositorysearch.create! valid_attributes
        put :update, {:id => repositorysearch.to_param, :repositorysearch => valid_attributes}, valid_session
        expect(response).to redirect_to(repositorysearch)
      end
    end

    describe "with invalid params" do
      it "assigns the repositorysearch as @repositorysearch" do
        repositorysearch = Repositorysearch.create! valid_attributes
        put :update, {:id => repositorysearch.to_param, :repositorysearch => invalid_attributes}, valid_session
        expect(assigns(:repositorysearch)).to eq(repositorysearch)
      end

      it "re-renders the 'edit' template" do
        repositorysearch = Repositorysearch.create! valid_attributes
        put :update, {:id => repositorysearch.to_param, :repositorysearch => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested repositorysearch" do
      repositorysearch = Repositorysearch.create! valid_attributes
      expect {
        delete :destroy, {:id => repositorysearch.to_param}, valid_session
      }.to change(Repositorysearch, :count).by(-1)
    end

    it "redirects to the repositorysearches list" do
      repositorysearch = Repositorysearch.create! valid_attributes
      delete :destroy, {:id => repositorysearch.to_param}, valid_session
      expect(response).to redirect_to(repositorysearches_url)
    end
  end

end
