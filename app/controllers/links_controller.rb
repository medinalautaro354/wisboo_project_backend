require 'securerandom'

class LinksController < ApplicationController
  before_action :set_link, only: [ :update, :destroy]

  # GET /links
  def index
    @links = Link.all

    render json: @links.to_json(:except => [:created_at, :updated_at])
  end

  # GET /links/AsddE33Xd
  def show
    randomString = params[:randomString]

    entity = Link.find_by("shortUrl like ?", "%#{randomString}%")

    entity.viewsCount += 1
    entity.save

    redirect_back fallback_location: entity.originalUrl
  end

  # POST /links
  def create
    @link = Link.new(link_para_post)

    stringRandom = SecureRandom.hex(6)
    entity = @link
    entity.viewsCount = 0;
    entity.shortUrl = "http://localhost:3000/links/" + stringRandom

    if !entity.originalUrl.include?('http') && !entity.originalUrl.include?('https')
      entity.originalUrl = "http://" + entity.originalUrl
    end
    
    if @link.save
      render json: @link, status: :created, location: @link
    else
      render json: @link.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /links/1
  def update
    if @link.update(link_params)
      render json: @link
    else
      render json: @link.errors, status: :unprocessable_entity
    end
  end

  # DELETE /links/1
  def destroy
    @link.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def link_params
      params.require(:link).permit(:shortUrl, :originalUrl, :viewsCount)
    end

    def link_para_post
      params.require(:link).permit(:originalUrl)
    end

end
