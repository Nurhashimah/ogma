require 'rails_helper'

RSpec.describe Campus::AddressBooksController, :type => :controller do
  
  # This should return the minimal set of attributes required to create a valid
  # AddressBook. As you add validations to AddressBook, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AddressBooksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all address_books as @address_books" do
      address_book = AddressBook.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:address_books)).to eq([address_book])
    end
  end

  describe "GET new" do
    before do
      @admin_user=FactoryGirl.create(:admin_user)
      sign_in(@admin_user)
    end
    it "assigns a new address_book as @address_book" do
      address_book = AddressBook.create! valid_attributes
      get :new, {}, valid_session
      expect(assigns(:address_book)).to be_a_new(AddressBook)
    end
  end

  describe "GET edit" do
    it "assigns the requested address_book as @address_book" do
      address_book = AddressBook.create! valid_attributes
      get :edit, {:id => address_book.to_param}, valid_session
      expect(assigns(:address_book)).to eq(address_book)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new AddressBook" do
        expect {
          post :create, {:address_book => valid_attributes}, valid_session
        }.to change(AddressBook, :count).by(1)
      end

      it "assigns a newly created address_book as @address_book" do
        post :create, {:address_book => valid_attributes}, valid_session
        expect(assigns(:address_book)).to be_a(AddressBook)
        expect(assigns(:address_book)).to be_persisted
      end

      it "redirects to the created address_book" do
        post :create, {:address_book => valid_attributes}, valid_session
        expect(response).to redirect_to(AddressBook.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved address_book as @address_book" do
        post :create, {:address_book => invalid_attributes}, valid_session
        expect(assigns(:address_book)).to be_a_new(AddressBook)
      end

      it "re-renders the 'new' template" do
        post :create, {:address_book => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested address_book" do
        address_book = AddressBook.create! valid_attributes
        put :update, {:id => address_book.to_param, :address_book => new_attributes}, valid_session
        address_book.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested address_book as @address_book" do
        address_book = AddressBook.create! valid_attributes
        put :update, {:id => address_book.to_param, :address_book => valid_attributes}, valid_session
        expect(assigns(:address_book)).to eq(address_book)
      end

      it "redirects to the address_book" do
        address_book = AddressBook.create! valid_attributes
        put :update, {:id => address_book.to_param, :address_book => valid_attributes}, valid_session
        expect(response).to redirect_to(address_book)
      end
    end

    describe "with invalid params" do
      it "assigns the address_book as @address_book" do
        address_book = AddressBook.create! valid_attributes
        put :update, {:id => address_book.to_param, :address_book => invalid_attributes}, valid_session
        expect(assigns(:address_book)).to eq(address_book)
      end

      it "re-renders the 'edit' template" do
        address_book = AddressBook.create! valid_attributes
        put :update, {:id => address_book.to_param, :address_book => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested address_book" do
      address_book = AddressBook.create! valid_attributes
      expect {
        delete :destroy, {:id => address_book.to_param}, valid_session
      }.to change(AddressBook, :count).by(-1)
    end

    it "redirects to the address_books list" do
      address_book = AddressBook.create! valid_attributes
      delete :destroy, {:id => address_book.to_param}, valid_session
      expect(response).to redirect_to(address_books_url)
    end
  end
  
end