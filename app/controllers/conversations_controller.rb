class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :edit, :update, :destroy, :new_message]
  before_action :authenticate_user!
  # GET /conversations
  # GET /conversations.json
  def index
    @conversations = Conversation.in(id: current_user.participates.pluck(:conversation_id).map(&:to_s)).all.entries
    @conversations = @conversations | current_user.conversations.all.entries
    if params[:id].present?
      @conversation = Conversation.find({id: params[:id]})
    else

      id = Message.last.conversation_id
      @conversation = Conversation.find({id: id}) if id.present?
      @conversation = Conversation.last if @conversation.nil?
    end
    @messages = @conversation&.messages
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
  end

  # GET /conversations/1/edit
  def edit
  end

  def new_message
    @message = current_user.messages.new(message_params)
    @message.save

    SendMessageJob.perform_later(@message.id.to_s)
     
     respond_to do |format|
      format.js
     end
  end

  def broadcast_message

    ApplicationController.renderer.instance_variable_set(:@env, {"HTTP_HOST"=>"localhost:2300", 
      "HTTPS"=>"off", 
      "REQUEST_METHOD"=>"GET", 
      "SCRIPT_NAME"=>"",   
      "warden" => warden}
    )

    html = ApplicationController.render(
      partial: 'conversations/messages',
      locals: { messages: @conversation.messages.entries.last(5) }
    )
    
    
     ActionCable.server.broadcast(
        "conversation_channel_#{@conversation.id.to_s}",
        sender_id: @message.sender_id.to_s,
        receiver_ids: @conversation.participators.pluck(:id).map(&:to_s),
        html: html,
        created_at: @message.created_at.localtime.strftime('%I:%M %p | %b %e')
      )   
  end  

  # POST /conversations
  # POST /conversations.json
  def create
    participates1 = current_user.participates.pluck(:conversation_id).map(&:to_s)
    participates2 = User.find(id: params[:user_id]).participates.pluck(:conversation_id).map(&:to_s)
    common = participates1 & participates2
    if common.empty?
      @conversation = current_user.conversations.create!(title: 'Personal')
      Participate.create!(conversation_id: @conversation.id, user_id: current_user.id)
      Participate.create!(conversation_id: @conversation.id, user_id: params[:user_id])
    else
      @conversation = Conversation.find(id: common[0])
    end
    respond_to do |format|
      if @conversation.save
        format.html { redirect_to conversations_path(id: @conversation.id) }
        format.json { render :show, status: :created, location: @conversation }
      else
        format.html { render :new }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conversations/1
  # PATCH/PUT /conversations/1.json
  def update
    respond_to do |format|
      if @conversation.update(conversation_params)
        format.html { redirect_to @conversation, notice: 'Conversation was successfully updated.' }
        format.json { render :show, status: :ok, location: @conversation }
      else
        format.html { render :edit }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.json
  def destroy
    @conversation.destroy
    respond_to do |format|
      format.html { redirect_to conversations_url, notice: 'Conversation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.find({id: params[:id]})
    end

    # Only allow a list of trusted parameters through.
    def conversation_params
      params.require(:conversation).permit(:title)
    end

    def message_params
      params.require(:message).permit(:conversation_id, :content)
    end
end
