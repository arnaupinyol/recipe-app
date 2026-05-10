module Api
  class BlocksController < BaseController
    before_action :authenticate_user!
    before_action :set_block, only: [ :show, :update, :destroy ]

    def index
      blocks = blocks_scope.order(blocked_at: :desc)

      render_success({ blocks: blocks.map { |block| BlockSerializer.render(block) } })
    end

    def show
      render_success({ block: BlockSerializer.render(@block) })
    end

    def create
      block = current_user.blocks_as_blocker.new(block_params)

      if block.save
        render_success({ block: BlockSerializer.render(block) }, status: :created)
      else
        render_error("Block creation failed", details: normalized_errors(block))
      end
    end

    def update
      if @block.update(block_params)
        render_success({ block: BlockSerializer.render(@block) })
      else
        render_error("Block update failed", details: normalized_errors(@block))
      end
    end

    def destroy
      @block.destroy
      render_success({ message: "Block deleted" })
    end

    private

    def blocks_scope
      scope = Block.includes(:blocker, :blocked)
      return scope if current_user.admin?

      scope.where(blocker_id: current_user.id)
    end

    def set_block
      @block = blocks_scope.find_by(id: params[:id])
      return if @block

      render_error("Block not found", status: :not_found)
    end

    def block_params
      params.require(:block).permit(:blocked_id)
    end

    def normalized_errors(record)
      details = record.errors.to_hash
      details[:blocked_id] = [ "contains an invalid value" ] if details.delete(:blocked) == [ "must exist" ]
      details
    end
  end
end
