class GossipsController < ApplicationController

  def index
    @gossip_id = params[:id]
  end

  def new
  end
  
  def create
    #Création du user
    @city_id = City.all.sample.id
    User.create(username: params['gossip_username'], city_id: @city_id)
   
    #Création du gossip
    @gossip = Gossip.new(user_id: User.last.id, title: params['gossip_title'], content: params['gossip_content'])
    if @gossip.save     # si ça marche, il redirige vers la page d'index du site
      flash[:success] = 'It worked : Gossip successfully added!'
      redirect_to gossips_path
    else      # sinon, il render la view new (qui est celle sur laquelle on est déjà)
      flash[:danger] = 'Something went wrong.'
      render 'new'
      flash.delete(:danger)
    end
  end




  def show
    @gossip_id = params[:id]
    @gossip_user_username = Gossip.find(params[:id]).user.username
    @gossip_user_id = Gossip.find(params[:id]).user.id
    @gossip_title = Gossip.find(params[:id]).title
    @gossip_content = Gossip.find(params[:id]).content
    @gossip_created_at = Gossip.find(params[:id]).created_at
  end

  def edit
    @gossip = Gossip.find(params[:id])
  end

  def update
    @gossip = Gossip.find(params[:id])
    if post_params = params.require(:gossip).permit(:title, :content)
      @gossip.update(post_params)
      flash[:success] = 'It worked : Gossip successfully edited!'
      redirect_to :gossip
    else
      flash[:danger] = 'Something went wrong.'
      render :edit
      flash.delete(:danger)
    end
  end

  def destroy
    @gossip = Gossip.find(params[:id])
    @gossip.destroy
    redirect_to gossips_path
  end
end
