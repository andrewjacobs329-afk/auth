class CompaniesController < ApplicationController

  def index
    # find all Company rows
    @companies = Company.all
    # render companies/index view
    render({ :template => "companies/index" })
  end

  def show
    # find the Company whose id is in the address
    @company = Company.find_by({ "id" => params["id"] })
    # find its contacts
    @contacts = Contact.where({ "company_id" => @company["id"] })
    # render companies/show view with details about the Company
    render({ :template => "companies/show" })
  end

  def new
    # render companies/new view, the form
    render({ :template => "companies/new" })
  end

  def create
    # start with a new Company
    company = Company.new
    # assign the form's values to the Company's columns
    company["name"] = params["name"]
    company["city"] = params["city"]
    company["state"] = params["state"]
    # save the Company row
    company.save
    # redirect the user
    redirect_to("/companies")
  end

  def edit
    # find the Company
    @company = Company.find_by({ "id" => params["id"] })
    # render companies/edit view, a form filled with its values
    render({ :template => "companies/edit" })
  end

  def update
    # find the Company
    company = Company.find_by({ "id" => params["id"] })
    # assign the form's values to the Company's columns
    company["name"] = params["name"]
    company["city"] = params["city"]
    company["state"] = params["state"]
    # save the Company row
    company.save
    # redirect the user
    redirect_to("/companies/" + company["id"].to_s)
  end

  def destroy
    # find the Company
    company = Company.find_by({ "id" => params["id"] })
    # destroy the Company row
    company.destroy
    # redirect the user
    redirect_to("/companies")
  end

end
