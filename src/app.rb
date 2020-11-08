require_relative "view/ruby2d"
require_relative "model/state"
require_relative "actions/actions"

class App
  def initialize
    @state = Model::initial_state    
  end

  def start
    @view = View::Ruby2dView.new(self)

    timer_thread = Thread.new { init_timer() }
    @view.start(@state)
    timer_thread.join
  end
  
  def init_timer()
    base_sleep = 0.5
    min_sleep_time = 0.1
    loop do
      if @state.game_finished
        puts 'Game finished'
        puts "Puntaje: #{@state.snake.positions.length - 2}"
        break
      end
      @state = Actions::move_snake(@state)
      # trigger movement
      @view.render(@state)
      aceleration = @state.snake.positions.length - 2
      sleeping_time = base_sleep - (0.04 * aceleration)
      if sleeping_time >= min_sleep_time
        sleep sleeping_time
      else
        sleep min_sleep_time
      end
    end
  end

  def send_action(action, params)
    new_state = Actions.send(action, @state, params)
    if new_state.hash != @state.hash
      @state = new_state
      @view.render(@state)
    end
  end
end

app = App.new
app.start