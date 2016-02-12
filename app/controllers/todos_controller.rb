class TodosController < ApplicationController
  before_action :set_todo, :set_todos

  def index
    @need_pages_js = true
  end

  def create
    todo = Todo.build(todos_params, current_user, params[:travel_id])
    todo.save!
    redirect_to travel_todos_path, info: 'やることを追加しました'
  end

  def update
    todo = Todo.where(travel_id: params[:travel_id]).find(params[:id])
    if todo.update(todos_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    Todo.where(travel_id: params[:travel_id]).find(params[:id]).destroy
    redirect_to travel_todos_path, info: 'やることを削除しました'
  end

  private
    def set_todo
      @todo = Todo.new
    end

    def set_todos
      @todos = Todo.where(travel_id: params[:travel_id]).order(created_at: :desc)
    end

    def todos_params
      params.require(:todo).permit(
        :detail, :deadline_at, :finished
      )
    end
end
